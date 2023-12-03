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

ActiveRecord::Schema[7.1].define(version: 2023_12_01_100515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "unit_moving_logs", force: :cascade do |t|
    t.bigint "unit_id"
    t.string "resident_name"
    t.date "move_in_on"
    t.date "move_out_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "unit_moving_logs_id_idx"
    t.index ["id"], name: "unit_moving_logs_id_unq_idx", unique: true
    t.index ["move_in_on"], name: "move_in_on_idx"
    t.index ["move_out_on"], name: "move_out_on_idx"
    t.index ["resident_name"], name: "resident_name_idx"
    t.index ["unit_id"], name: "index_unit_moving_logs_on_unit_id"
    t.index ["unit_id"], name: "unit_id_idx"
  end

  create_table "units", force: :cascade do |t|
    t.string "floor_plan", null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["floor_plan"], name: "floor_plan_idx"
    t.index ["id"], name: "id_idx"
    t.index ["id"], name: "id_unq_idx", unique: true
    t.index ["number"], name: "number_idx"
  end

end
