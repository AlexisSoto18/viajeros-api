class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reservable, polymorphic: true, null: false

      t.integer :quantity, null: false, default: 1
      t.string  :status,   null: false, default: "pending" # pending/accepted/rejected/cancelled
      t.text    :notes

      t.timestamps
    end

    add_index :reservations, [:reservable_type, :reservable_id]
  end
end
