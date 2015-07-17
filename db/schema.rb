# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150717160207) do

  create_table "locations", force: :cascade do |t|
    t.integer "landlord_id"
    t.string  "nickname"
    t.string  "address"
    t.float   "rate"
    t.float   "interest_rate"
    t.boolean "allow_pets?"
    t.integer "no_people"
    t.string  "photo"
    t.string  "city"
    t.string  "country"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at"
    t.float    "amount",      null: false
    t.integer  "landlord_id", null: false
    t.integer  "tenant_id",   null: false
    t.integer  "location_id", null: false
  end

  create_table "records", force: :cascade do |t|
    t.integer  "tenant_id",   null: false
    t.integer  "landlord_id", null: false
    t.integer  "location_id", null: false
    t.integer  "amount_due",  null: false
    t.integer  "amount_paid"
    t.datetime "date_due"
    t.datetime "date_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name",            null: false
    t.string  "email",           null: false
    t.string  "password",        null: false
    t.integer "location_id"
    t.string  "phone"
    t.boolean "pets"
    t.float   "account_balance"
    t.string  "credit_card"
    t.integer "usertype",        null: false
  end

end
