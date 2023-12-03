require "test_helper"

class RentRollReportServiceTest < ActiveSupport::TestCase
  setup do
    @date = Date.today
    unit1 = Unit.create({ number: 1, floor_plan: Unit::FLOOR_PLANS[:studio] })
    unit2 = Unit.create({ number: 2, floor_plan: Unit::FLOOR_PLANS[:studio] })
    unit3 = Unit.create({ number: 3, floor_plan: Unit::FLOOR_PLANS[:studio] })

    unit1.unit_moving_logs.create(
      {
        unit_id: 1,
        resident_name: "Crazy Horse",
        move_in_on: "6/2/2020",
        move_out_on: "6/2/2022",
      }
    )
    unit2.unit_moving_logs.create(
      {
        unit_id: 2,
        resident_name: "Sitting Bull",
        move_in_on: "6/3/2020",
      }
    )
    unit3.unit_moving_logs.create(
      {
        unit_id: 3,
        resident_name: "Long Horn",
        move_in_on: @date + 1,
      }
    )
  end

  test "#occupied_units" do
    report = RentRollReportService.new(@date).occupied_units

    first_unit = report.first
    assert_equal "2", first_unit[:unit]
    assert_equal "Studio", first_unit[:floor_plan]
    assert_equal "Sitting Bull", first_unit[:resident]
    assert_equal "2020-03-06", first_unit[:move_in_date].strftime("%Y-%m-%d")
    assert_equal "N/A", first_unit[:move_out_date]
  end

  test "#leased_units" do
    report = RentRollReportService.new(@date).leased_units

    first_unit = report.first
    second_unit = report.second

    assert_equal "2", first_unit[:unit]
    assert_equal "Studio", first_unit[:floor_plan]
    assert_equal "Sitting Bull", first_unit[:resident]
    assert_equal "2020-03-06", first_unit[:move_in_date].strftime("%Y-%m-%d")
    assert_equal "N/A", first_unit[:move_out_date]

    assert_equal "3", second_unit[:unit]
    assert_equal "Studio", second_unit[:floor_plan]
    assert_equal "Long Horn", second_unit[:resident]
    assert_equal (@date + 1).strftime("%Y-%m-%d"), second_unit[:move_in_date].strftime("%Y-%m-%d")
    assert_equal "N/A", second_unit[:move_out_date]
  end

  test "#vacant_units" do
    report = RentRollReportService.new(@date).vacant_units

    first_unit = report.first
    second_unit = report.second

    assert_equal "1", first_unit[:unit]
    assert_equal "Studio", first_unit[:floor_plan]
    assert_equal "Crazy Horse", first_unit[:resident]
    assert_equal "2020-02-06", first_unit[:move_in_date].strftime("%Y-%m-%d")
    assert_equal "N/A", second_unit[:move_out_date]

    assert_equal "3", second_unit[:unit]
    assert_equal "Studio", second_unit[:floor_plan]
    assert_equal "Long Horn", second_unit[:resident]
    assert_equal (@date + 1).strftime("%Y-%m-%d"), second_unit[:move_in_date].strftime("%Y-%m-%d")
    assert_equal "N/A", second_unit[:move_out_date]
  end

  test "#report" do
    report = RentRollReportService.new(@date).report

    assert_equal 1, report[:total_occupied_units]
    assert_equal 2, report[:total_leased_units]
    assert_equal 2, report[:total_vacant_units]
  end
end