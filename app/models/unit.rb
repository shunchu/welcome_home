class Unit < ApplicationRecord
  FLOOR_PLANS = {
    studio: "Studio",
    suite: "Suite",
  }.freeze

  has_many :unit_moving_logs

  validates :floor_plan, :number, presence: true
  validates :floor_plan, inclusion: { in: FLOOR_PLANS.values }

  def self.occupied_units(date)
    units = includes(:unit_moving_logs)
              .where("unit_moving_logs.move_in_on < ?", date)
              .where(unit_moving_logs: {
                move_out_on: nil,
                unit_id: self.ids,
              })

    sort_by_unit_number(units)
  end

  def self.leased_units
    units = includes(:unit_moving_logs)
      .where(unit_moving_logs: {
        move_out_on: nil,
        unit_id: self.ids,
      })

    sort_by_unit_number(units)
  end

  def self.vacant_units(date)
    units = all - occupied_units(date)
    sort_by_unit_number(units)
  end

  private

  def self.sort_by_unit_number(units)
    units.sort do |a, b|
      a_num = a.number.to_i
      b_num = b.number.to_i

      a_num == b_num ?
        a <=> b :
        a_num <=> b_num
    end
  end
end
