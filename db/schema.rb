# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_26_040337) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "pueblo_magico_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.text "images", default: [], array: true
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.string "location"
    t.integer "slots_total", default: 0, null: false
    t.integer "slots_available", default: 0, null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pueblo_magico_id", "approved"], name: "index_events_on_pueblo_magico_id_and_approved"
    t.index ["pueblo_magico_id"], name: "index_events_on_pueblo_magico_id"
    t.index ["starts_at"], name: "index_events_on_starts_at"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "pueblo_magico_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "company", null: false
    t.text "description"
    t.string "status", default: "open", null: false
    t.boolean "approved", default: false, null: false
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pueblo_magico_id", "approved", "status"], name: "index_jobs_on_pueblo_magico_id_and_approved_and_status"
    t.index ["pueblo_magico_id"], name: "index_jobs_on_pueblo_magico_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.bigint "pueblo_magico_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "kind", null: false
    t.text "description"
    t.text "images", default: [], array: true
    t.string "address"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lon", precision: 10, scale: 6
    t.integer "slots_total", default: 0, null: false
    t.integer "slots_available", default: 0, null: false
    t.time "opens_at"
    t.time "closes_at"
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pueblo_magico_id", "approved", "kind"], name: "index_places_on_pueblo_magico_id_and_approved_and_kind"
    t.index ["pueblo_magico_id"], name: "index_places_on_pueblo_magico_id"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "pueblo_magicos", force: :cascade do |t|
    t.string "nombre"
    t.string "region"
    t.text "descripcion"
    t.string "descripcion_corta"
    t.text "imagenes", default: [], array: true
    t.decimal "latitud"
    t.decimal "longitud"
    t.integer "poblacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reservable_type", null: false
    t.bigint "reservable_id", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", default: "pending", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservable_type", "reservable_id"], name: "index_reservations_on_reservable"
    t.index ["reservable_type", "reservable_id"], name: "index_reservations_on_reservable_type_and_reservable_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "full_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "events", "pueblo_magicos"
  add_foreign_key "events", "users"
  add_foreign_key "jobs", "pueblo_magicos"
  add_foreign_key "jobs", "users"
  add_foreign_key "places", "pueblo_magicos"
  add_foreign_key "places", "users"
  add_foreign_key "reservations", "users"
end
