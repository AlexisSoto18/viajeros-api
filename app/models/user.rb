class User < ApplicationRecord
  enum :role, { turista: "turista", anfitrion: "anfitrion", admin: "admin" }

  # Alias para que funcionen host?/tourist?
  def admin?   = super
  def host?    = anfitrion?
  def tourist? = turista?

  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :turista
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
