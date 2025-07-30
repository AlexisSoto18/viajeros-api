class CreatePuebloMagicos < ActiveRecord::Migration[8.0]
  def change
    create_table :pueblo_magicos do |t|
      t.string :nombre
      t.string :region
      t.text :descripcion
      t.string :descripcion_corta
      t.text :imagenes, array: true, default: []
      t.decimal :latitud
      t.decimal :longitud
      t.integer :poblacion

      t.timestamps
    end
  end
end
