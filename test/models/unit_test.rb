require "test_helper"

CSV_FILE_PATH = "./test/services/csv/clean.csv"

class UnitTest < ActiveSupport::TestCase
  setup do
    @today = Date.today
  end

  test "add unit with no other data" do
    unit = Unit.create(
      floor_plan: Unit::FLOOR_PLANS[:studio],
      number: 1,
    )

    assert_equal "1", unit.number
    assert_equal "Studio", unit.floor_plan
  end

  test "add unit with invalid floor plan key" do
    unit = Unit.new(
      floor_plan: :penthouse,
      number: 1,
    )

    assert !unit.valid?
    assert_match /['penthouse' is not a valid floor_plan]/, unit.errors.full_messages.to_s
  end

  test "#vacant_units" do
    UnitsResidentsCsvImportService.new(CSV_FILE_PATH).import
    Unit.create(
      floor_plan: Unit::FLOOR_PLANS[:suite],
      number: 3
    )

    vacant_units = Unit.vacant_units @today
    assert_equal 2, vacant_units.count
    assert_equal %w[3 10], vacant_units.pluck(:number)
  end

  test "#occupied_units" do
    UnitsResidentsCsvImportService.new(CSV_FILE_PATH).import
    Unit.first.update(
      number: "2"
    )

    Unit.last.unit_moving_logs.create(
      move_in_on: "12/12/2019",
      resident_name: "Crazy Horse",
    )

    occupied_units = Unit.occupied_units @today
    assert_equal 2, occupied_units.count
    assert_equal %w[2 10], occupied_units.pluck(:number)
  end

  test "#leased_units" do
    UnitsResidentsCsvImportService.new(CSV_FILE_PATH).import
    Unit.first.update(
      number: "2"
    )

    Unit.last.unit_moving_logs.create(
      move_in_on: @today + 1,
      resident_name: "Crazy Horse",
    )

    leased_units = Unit.leased_units
    assert_equal 2, leased_units.count
    assert_equal %w[2 10], leased_units.pluck(:number)
  end
end
