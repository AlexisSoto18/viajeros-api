class CreatePlaces < ActiveRecord::Migration[7.2]
  def change
    create_table :places do |t|
      t.references :pueblo_magico, null: false, foreign_key: true
      t.references :user,          null: false, foreign_key: true

      t.string  :name,  null: false
      t.string  :kind,  null: false   # 'attraction','restaurant','lodging','commerce'
      t.text    :description
      t.text    :images, array: true, default: []  # <-- AQUÍ el arreglo

      t.string  :address
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lon, precision: 10, scale: 6

      t.integer :slots_total,     null: false, default: 0
      t.integer :slots_available, null: false, default: 0
      t.time    :opens_at
      t.time    :closes_at

      t.boolean :approved, null: false, default: false

      t.timestamps
    end

    add_index :places, [:pueblo_magico_id, :approved, :kind]
  end
end
