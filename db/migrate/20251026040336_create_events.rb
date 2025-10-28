class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.references :pueblo_magico, null: false, foreign_key: true
      t.references :user,          null: false, foreign_key: true

      t.string  :title, null: false
      t.text    :description
      t.text    :images, array: true, default: []

      t.datetime :starts_at, null: false
      t.datetime :ends_at,   null: false
      t.string   :location

      t.integer :slots_total,     null: false, default: 0
      t.integer :slots_available, null: false, default: 0

      t.boolean :approved, null: false, default: false

      t.timestamps
    end

    add_index :events, [:pueblo_magico_id, :approved]
    add_index :events, :starts_at
  end
end
