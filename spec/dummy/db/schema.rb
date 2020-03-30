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

ActiveRecord::Schema.define(version: 2020_03_25_132733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exception_hunter_errors", force: :cascade do |t|
    t.string "class_name", null: false
    t.string "message"
    t.datetime "ocurred_at", null: false
    t.json "environment_data"
    t.json "custom_data"
    t.string "backtrace", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
