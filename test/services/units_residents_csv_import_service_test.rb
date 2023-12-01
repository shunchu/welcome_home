require "test_helper"
require "csv"

PATH = "./test/services/csv"

class UnitsResidentsCsvImportServiceTest < ActiveSupport::TestCase
  test "clean csv file imports properly" do
    import_service = UnitsResidentsCsvImportService.new("#{PATH}/clean.csv")
    import_service.import

    occupied_unit = Unit.first
    assert_equal "1", occupied_unit.number
    assert_equal "Studio", occupied_unit.floor_plan
    assert_equal "2021-01-01", occupied_unit.move_in_on.strftime("%Y-%m-%d")
    assert_not_nil occupied_unit.resident

    empty_unit = Unit.last
    assert_equal "10", empty_unit.number
    assert_equal "Studio", empty_unit.floor_plan
    assert_nil empty_unit.move_in_on
    assert_nil empty_unit.resident
  end

  test "csv missing resident name" do
    import_service = UnitsResidentsCsvImportService.new("#{PATH}/malformed_missing_name.csv")
    import_service.import

    unit = Unit.first
    assert unit.nil?
  end

  test "csv missing move in date if resident name is present" do
    import_service = UnitsResidentsCsvImportService.new("#{PATH}/malformed_missing_move_in.csv")
    import_service.import

    unit = Unit.first
    assert unit.nil?
  end
end
