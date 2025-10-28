class Event < ApplicationRecord
  belongs_to :pueblo_magico
  belongs_to :user
  has_many :reservations, as: :reservable, dependent: :destroy

  validates :title, :starts_at, :ends_at, presence: true
  validate :ends_after_starts

  scope :approved, -> { where(approved: true) }

  def ends_after_starts
    errors.add(:ends_at, "must be after starts_at") if starts_at && ends_at && ends_at <= starts_at
  end
end
