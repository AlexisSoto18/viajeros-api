class PuebloMagico < ApplicationRecord
  has_many :places, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :jobs,   dependent: :destroy
  validates :nombre, :region, :descripcion, :descripcion_corta, :latitud, :longitud, :poblacion, presence: true
end
