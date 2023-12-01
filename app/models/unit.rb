class Unit < ApplicationRecord
  FLOOR_PLANS = {
    studio: "Studio",
    suite: "Suite",
  }.freeze

  belongs_to :resident, optional: true

  validates :floor_plan, :number, presence: true
  validates :move_in_on, presence: true, if: -> { self.resident.present? }
end
