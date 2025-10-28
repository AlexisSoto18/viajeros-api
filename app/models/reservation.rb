class Reservation < ApplicationRecord
  belongs_to :user                 # turista que reserva
  belongs_to :reservable, polymorphic: true

  STATUSES = %w[pending accepted rejected cancelled].freeze
  validates :status, inclusion: { in: STATUSES }
  validates :quantity, numericality: { greater_than: 0 }
end
