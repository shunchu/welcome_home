class RentRollReportService
  def initialize(date)
    @date = date
  end

  def occupied_units
    occupied_report = []

    Unit.occupied_units(@date).each do |unit|
      resident = unit.unit_moving_logs&.first&.resident_name
      move_in_date = unit.unit_moving_logs&.first&.move_in_on
      move_out_date = unit.unit_moving_logs&.first&.move_out_on || "N/A"

      occupied_report << {
        unit: unit.number,
        floor_plan: unit.floor_plan,
        resident: resident,
        move_in_date: move_in_date,
        move_out_date: move_out_date,
      }
    end

    occupied_report
  end

  def leased_units
    leased_report = []

    Unit.leased_units.each do |unit|
      resident = unit.unit_moving_logs&.first&.resident_name
      move_in_date = unit.unit_moving_logs&.first&.move_in_on
      move_out_date = unit.unit_moving_logs&.first&.move_out_on || "N/A"

      leased_report << {
        unit: unit.number,
        floor_plan: unit.floor_plan,
        resident: resident,
        move_in_date: move_in_date,
        move_out_date: move_out_date,
      }
    end

    leased_report
  end

  def vacant_units
    vacant_report = []

    Unit.vacant_units(@date).each do |unit|
      resident = unit.unit_moving_logs&.first&.resident_name || "N/A"
      move_in_date = unit.unit_moving_logs&.first&.move_in_on || "N/A"
      move_out_date = unit.unit_moving_logs&.first&.move_out_on || "N/A"

      vacant_report << {
        unit: unit.number,
        floor_plan: unit.floor_plan,
        resident: resident,
        move_in_date: move_in_date,
        move_out_date: move_out_date,
      }
    end

    vacant_report
  end

  def report
    {
      total_occupied_units: Unit.occupied_units(@date).size,
      total_leased_units: Unit.leased_units.size,
      total_vacant_units: Unit.vacant_units(@date).size,
    }
  end
end