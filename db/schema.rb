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

ActiveRecord::Schema[7.1].define(version: 2024_11_06_211908) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "cigarette_brands", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_per_pack", null: false
    t.integer "quantity_per_pack", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cigarette_brands_on_name", unique: true
  end

  create_table "cigarettes", force: :cascade do |t|
    t.string "brand", null: false
    t.integer "quantity_per_pack", null: false
    t.integer "price_per_pack", null: false
    t.decimal "price_per_cigarette", precision: 4, scale: 2, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cigarettes_on_user_id"
  end

  create_table "quit_smoking_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "daily_smoking_amount", null: false
    t.index ["user_id"], name: "index_quit_smoking_records_on_user_id"
  end

  create_table "savings_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quit_smoking_record_id", null: false
    t.integer "target_amount", null: false
    t.datetime "start_date", null: false
    t.datetime "achieved_at"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quit_smoking_record_id"], name: "index_savings_goals_on_quit_smoking_record_id"
    t.index ["user_id", "status"], name: "index_savings_goals_on_user_id_and_status"
    t.index ["user_id"], name: "index_savings_goals_on_user_id"
  end

  create_table "smoking_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cigarette_id", null: false
    t.decimal "price_per_cigarette", precision: 4, scale: 2, null: false
    t.datetime "smoked_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brand_name", null: false
    t.index ["cigarette_id"], name: "index_smoking_records_on_cigarette_id"
    t.index ["user_id", "smoked_at"], name: "index_smoking_records_on_user_id_and_smoked_at"
    t.index ["user_id"], name: "index_smoking_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "smoking_status", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "cigarettes", "users"
  add_foreign_key "quit_smoking_records", "users"
  add_foreign_key "savings_goals", "quit_smoking_records"
  add_foreign_key "savings_goals", "users"
  add_foreign_key "smoking_records", "cigarettes"
  add_foreign_key "smoking_records", "users"
end
