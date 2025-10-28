class Job < ApplicationRecord
  belongs_to :pueblo_magico
  belongs_to :user
  validates :title, :company, :description, presence: true

  STATUSES = %w[open closed].freeze
  validates :status, inclusion: { in: STATUSES }

  scope :approved, -> { where(approved: true) }
  scope :open_only, -> { where(status: 'open') }
end
