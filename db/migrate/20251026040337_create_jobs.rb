class CreateJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :jobs do |t|
      t.references :pueblo_magico, null: false, foreign_key: true
      t.references :user,          null: false, foreign_key: true

      t.string :title,   null: false
      t.string :company, null: false
      t.text   :description

      t.string :status,  null: false, default: "open"  # <-- default AQUÍ
      t.boolean :approved, null: false, default: false
      t.string :contact_email

      t.timestamps
    end

    add_index :jobs, [:pueblo_magico_id, :approved, :status]
  end
end
