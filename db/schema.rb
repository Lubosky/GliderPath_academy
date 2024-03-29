# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170402135927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "product"
    t.decimal "amount"
    t.string "stripe_charge_id"
    t.string "card_brand"
    t.integer "card_exp_month"
    t.integer "card_exp_year"
    t.string "card_last4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_charge_id"], name: "index_charges_on_stripe_charge_id", unique: true
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instructor_id"
    t.decimal "price", precision: 6, scale: 2
    t.string "slug", null: false
    t.string "short_description"
    t.datetime "published_at"
    t.index ["instructor_id"], name: "index_courses_on_instructor_id"
    t.index ["published_at"], name: "index_courses_on_published_at"
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "enrolled_lessons", id: :serial, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "student_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id"
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "notes"
    t.integer "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "slug", null: false
    t.index ["section_id"], name: "index_lessons_on_section_id"
    t.index ["slug"], name: "index_lessons_on_slug", unique: true
  end

  create_table "plans", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "stripe_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchases", id: :serial, force: :cascade do |t|
    t.string "stripe_charge_id"
    t.integer "purchaser_id", null: false
    t.string "purchasable_type", null: false
    t.integer "purchasable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchasable_type", "purchasable_id"], name: "index_purchases_on_purchasable_type_and_purchasable_id"
    t.index ["purchaser_id", "purchasable_type", "purchasable_id"], name: "index_purchases_on_purchaser_id_purchasable_type_purchasable_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "objective"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.string "stripe_subscription_id"
    t.integer "plan_id", null: false
    t.integer "subscriber_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "canceled_on"
    t.date "scheduled_for_cancellation_on"
    t.index ["subscriber_id", "plan_id"], name: "index_subscriptions_on_subscriber_id_and_plan_id"
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.jsonb "file_data", null: false
    t.integer "uploader_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uploadable_type", null: false
    t.integer "uploadable_id", null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_uploads_on_uploadable_type_and_uploadable_id"
    t.index ["uploader_id"], name: "index_uploads_on_uploader_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.jsonb "avatar_data"
    t.text "bio"
    t.string "headline"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "video_url"
    t.string "video_id"
    t.string "video_embed_url"
    t.string "video_provider"
    t.integer "video_duration"
    t.string "videoable_type"
    t.integer "videoable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["videoable_type", "videoable_id"], name: "index_videos_on_videoable_type_and_videoable_id"
  end

  create_table "workshops", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.text "notes"
    t.decimal "price", precision: 6, scale: 2
    t.string "slug", null: false
    t.integer "instructor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["instructor_id"], name: "index_workshops_on_instructor_id"
    t.index ["published_at"], name: "index_workshops_on_published_at"
    t.index ["slug"], name: "index_workshops_on_slug", unique: true
  end

  add_foreign_key "courses", "users", column: "instructor_id"
  add_foreign_key "enrolled_lessons", "users", column: "student_id"
  add_foreign_key "enrollments", "users", column: "student_id"
  add_foreign_key "lessons", "sections"
  add_foreign_key "purchases", "users", column: "purchaser_id"
  add_foreign_key "sections", "courses"
  add_foreign_key "subscriptions", "users", column: "subscriber_id"
  add_foreign_key "uploads", "users", column: "uploader_id"
  add_foreign_key "workshops", "users", column: "instructor_id"
end
