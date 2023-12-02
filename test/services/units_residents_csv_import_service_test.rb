require "test_helper"

PATH = "./test/services/csv"

class UnitsResidentsCsvImportServiceTest < ActiveSupport::TestCase
  test "clean csv file imports properly" do
    import_service = UnitsResidentsCsvImportService.new("#{PATH}/clean.csv")
    import_service.import

    occupied_unit = Unit.first
    moving_log = occupied_unit.unit_moving_logs.first
    assert_equal "1", occupied_unit.number
    assert_equal "Studio", occupied_unit.floor_plan
    assert_equal "2021-01-01", moving_log
                                     &.move_in_on
                                     &.strftime("%Y-%m-%d")
    assert_not_nil moving_log&.resident_name

    empty_unit = Unit.last
    assert_equal "10", empty_unit.number
    assert_equal "Studio", empty_unit.floor_plan
    assert_empty empty_unit.unit_moving_logs
  end

  test "csv missing move in date if resident name is present" do
    import_service = UnitsResidentsCsvImportService.new("#{PATH}/malformed_missing_move_in.csv")
    import_service.import

    unit = Unit.first
    assert_empty unit.unit_moving_logs
  end
end
