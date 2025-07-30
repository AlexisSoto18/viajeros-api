class PuebloMagico < ApplicationRecord
  validates :nombre, :region, :descripcion, :descripcion_corta, :latitud, :longitud, :poblacion, presence: true
end
