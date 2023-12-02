require "test_helper"

class UnitTest < ActiveSupport::TestCase
  test "add unit with no other data" do
    Unit.create(
      floor_plan: Unit::FLOOR_PLANS[:studio],
      move_in_on: nil,
      move_out_on: nil,
      number: "1",
      resident_name: nil,
    )

    unit = Unit.first
    assert_equal "1", unit.number
    assert_equal "Studio", unit.floor_plan
  end

  test "add unit with resident and move-in data" do
    Unit.create(
      floor_plan: Unit::FLOOR_PLANS[:studio],
      move_in_on: "2021-12-13",
      move_out_on: nil,
      number: "1",
      resident_name: "Crazy Horse",
    )

    unit = Unit.first
    assert_equal "2021-12-13", unit.move_in_on.strftime("%Y-%m-%d")
    assert_nil unit.move_out_on
    assert_equal "Crazy Horse", unit.resident_name
  end

  test "add unit with resident but without move-in data" do
    Unit.create(
      floor_plan: Unit::FLOOR_PLANS[:studio],
      move_in_on: nil,
      move_out_on: nil,
      number: "1",
      resident_name: "Crazy Horse",
    )

    unit = Unit.first
    assert_nil unit
  end
end
