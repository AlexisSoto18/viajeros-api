class User < ApplicationRecord
  enum :role, {
    turista: "turista",
    anfitrion: "anfitrion",
    admin: "admin" }

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :turista
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
