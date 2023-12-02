class Unit < ApplicationRecord
  FLOOR_PLANS = {
    studio: "Studio",
    suite: "Suite",
  }.freeze

  validates :floor_plan, :number, presence: true
  validates :move_in_on, presence: true, if: -> { resident_name.present? }
end
