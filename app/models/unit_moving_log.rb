class UnitMovingLog < ApplicationRecord

  belongs_to :unit

  validates :move_in_on, presence: true, if: -> { resident_name.present? }
  validates :resident_name, presence: true, if: -> { :move_in_on.present? }

end
