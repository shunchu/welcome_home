require "test_helper"

class UnitMovingLogTest < ActiveSupport::TestCase
  setup do
    @unit = Unit.create(number: 1, floor_plan: Unit::FLOOR_PLANS[:studio])
  end

  test "add moving log with clean data" do
    resident_name = "Crazy Horse"

    moving_log = @unit.unit_moving_logs.create(
      move_in_on: "2022-12-1",
      move_out_on: "2023-12-1",
      resident_name: resident_name,
    )

    assert_equal "2022-12-01", moving_log.move_in_on.strftime("%Y-%m-%d")
    assert_equal "2023-12-01", moving_log.move_out_on.strftime("%Y-%m-%d")
    assert_equal resident_name, moving_log.resident_name
  end

  test "add moving log without move-in date" do
    moving_log = @unit.unit_moving_logs.create(
      move_in_on: nil,
      move_out_on: nil,
      resident_name: "Crazy Horse",
    )

    assert !moving_log.valid?
  end

  test "add moving log without resident name" do
    moving_log = @unit.unit_moving_logs.create(
      move_in_on: "12/1/2022",
      move_out_on: nil,
      resident_name: nil,
    )

    assert !moving_log.valid?
  end
end
