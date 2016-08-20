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

ActiveRecord::Schema.define(version: 20160819142211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "product"
    t.decimal  "amount"
    t.string   "stripe_charge_id"
    t.string   "card_brand"
    t.integer  "card_exp_month"
    t.integer  "card_exp_year"
    t.string   "card_last4"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["stripe_charge_id"], name: "index_charges_on_stripe_charge_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_charges_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "instructor_id"
    t.decimal  "price",             precision: 6, scale: 2
    t.string   "slug",                                      null: false
    t.string   "short_description"
    t.index ["instructor_id"], name: "index_courses_on_instructor_id", using: :btree
    t.index ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
  end

  create_table "enrolled_lessons", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "student_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "notes"
    t.integer  "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
    t.string   "slug",       null: false
    t.index ["section_id"], name: "index_lessons_on_section_id", using: :btree
    t.index ["slug"], name: "index_lessons_on_slug", unique: true, using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",           null: false
    t.string   "stripe_plan_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.string   "stripe_charge_id"
    t.integer  "purchaser_id",     null: false
    t.string   "purchasable_type", null: false
    t.integer  "purchasable_id",   null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["purchasable_type", "purchasable_id"], name: "index_purchases_on_purchasable_type_and_purchasable_id", using: :btree
    t.index ["purchaser_id", "purchasable_type", "purchasable_id"], name: "index_purchases_on_purchaser_id_purchasable_type_purchasable_id", unique: true, using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "objective"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
    t.index ["course_id"], name: "index_sections_on_course_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_subscription_id"
    t.integer  "plan_id",                       null: false
    t.integer  "subscriber_id",                 null: false
    t.string   "status"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "canceled_on"
    t.date     "scheduled_for_cancellation_on"
    t.index ["subscriber_id", "plan_id"], name: "index_subscriptions_on_subscriber_id_and_plan_id", using: :btree
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "file_id",           null: false
    t.string   "file_filename",     null: false
    t.integer  "file_size",         null: false
    t.string   "file_content_type", null: false
    t.integer  "uploader_id",       null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "uploadable_type",   null: false
    t.integer  "uploadable_id",     null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_uploads_on_uploadable_type_and_uploadable_id", using: :btree
    t.index ["uploader_id"], name: "index_uploads_on_uploader_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "stripe_customer_id"
    t.string   "avatar_id"
    t.text     "bio"
    t.string   "headline"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "video_url"
    t.string   "video_id"
    t.string   "video_embed_url"
    t.string   "video_provider"
    t.integer  "video_duration"
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["videoable_type", "videoable_id"], name: "index_videos_on_videoable_type_and_videoable_id", using: :btree
  end

  create_table "workshops", force: :cascade do |t|
    t.string   "name"
    t.string   "short_description"
    t.text     "notes"
    t.decimal  "price",             precision: 6, scale: 2
    t.string   "slug",                                      null: false
    t.integer  "instructor_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["instructor_id"], name: "index_workshops_on_instructor_id", using: :btree
    t.index ["slug"], name: "index_workshops_on_slug", unique: true, using: :btree
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
