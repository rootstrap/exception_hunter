# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_13_030831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "exception_hunter_error_groups", force: :cascade do |t|
    t.string "message"
    t.string "error_class_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message"], name: "index_exception_hunter_error_groups_on_message", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "exception_hunter_errors", force: :cascade do |t|
    t.string "class_name", null: false
    t.string "message"
    t.datetime "occurred_at", null: false
    t.json "environment_data"
    t.json "custom_data"
    t.string "backtrace", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "error_group_id"
    t.index ["error_group_id"], name: "index_exception_hunter_errors_on_error_group_id"
  end

  add_foreign_key "exception_hunter_errors", "exception_hunter_error_groups", column: "error_group_id"
end
