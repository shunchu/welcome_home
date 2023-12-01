require "csv"

class UnitsResidentsCsvImportService
  def initialize(file)
    @file = file
    @counters = {
      total_imported: 0,
      rows_failed: 0,
      failed_reasons: [],
    }
  end

  def import
    execute_import
  end

  private

  def execute_import
      CSV.read(@file, headers: true).each do |row|
        resident_names = row["resident"]&.split(" ")
        resident = nil

        if resident_names
          resident = Resident.find_or_create_by(
            first_name: resident_names[0],
            last_name: resident_names[1],
          )
        end

        unit_floor_plan = Unit::FLOOR_PLANS[row["floor_plan"].downcase.to_sym]
        unit_num = row["unit"]
        # NOTE: Not taking into consideration timezones
        unit_move_in_on = row["move_in"].nil? ?
                            nil :
                            Date.strptime(row["move_in"], "%m/%d/%Y")
        unit_move_out_on = row["move_out"].nil? ?
                             nil :
                             Date.strptime(row["move_out"], "%m/%d/%Y")

        if resident&.errors.present?
          @counters[:rows_failed] += 1
          @counters[:failed_reasons] << "Unit ##{unit_num}: #{resident&.errors&.full_messages.to_s}"
          next
        end

        unit = Unit.create!(
          floor_plan: unit_floor_plan,
          move_in_on: unit_move_in_on,
          move_out_on: unit_move_out_on,
          number: unit_num,
          resident: resident,
        )

        if unit&.errors.present?
          @counters[:rows_failed] += 1
          @counters[:failed_reasons] << "Unit ##{unit_num}: #{unit&.errors&.full_messages.to_s}"
          next
        end

        @counters[:total_imported] += 1

        puts "Unit #{unit_num} created!"
      end


    puts @counters
  end
end