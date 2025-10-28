class Place < ApplicationRecord
  belongs_to :pueblo_magico
  belongs_to :user       # host que lo creó
  has_many :reservations, as: :reservable, dependent: :destroy

  KINDS = %w[attraction restaurant lodging commerce].freeze
  validates :name, :kind, presence: true
  validates :kind, inclusion: { in: KINDS }

  scope :approved, -> { where(approved: true) }
end
