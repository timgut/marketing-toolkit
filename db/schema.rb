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

ActiveRecord::Schema.define(version: 20170721183442) do

  create_table "affiliates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "state"
    t.string   "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.text     "description", limit: 65535
    t.integer  "status"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "parent_id"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "document_id"
    t.string   "key"
    t.text     "value",       limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "field_id"
    t.index ["document_id"], name: "index_data_on_document_id", using: :btree
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "template_id"
    t.string   "title"
    t.text     "description",            limit: 65535
    t.integer  "status"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "tag_id"
    t.integer  "creator_id"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.boolean  "crop_marks",                           default: false
    t.index ["creator_id"], name: "index_documents_on_creator_id", using: :btree
    t.index ["template_id"], name: "index_documents_on_template_id", using: :btree
  end

  create_table "documents_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["document_id"], name: "index_documents_users_on_document_id", using: :btree
    t.index ["user_id"], name: "index_documents_users_on_user_id", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "creator_id"
    t.integer  "status",                           default: 1, null: false
    t.text     "crop_data",          limit: 65535
    t.text     "image_meta",         limit: 65535
    t.index ["creator_id"], name: "index_images_on_creator_id", using: :btree
  end

  create_table "images_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "image_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_images_users_on_image_id", using: :btree
    t.index ["user_id"], name: "index_images_users_on_user_id", using: :btree
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.text     "description",                 limit: 65535
    t.float    "height",                      limit: 24
    t.float    "width",                       limit: 24
    t.text     "pdf_markup",                  limit: 65535
    t.text     "form_markup",                 limit: 65535
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "numbered_image_file_name"
    t.string   "numbered_image_content_type"
    t.integer  "numbered_image_file_size"
    t.datetime "numbered_image_updated_at"
    t.string   "blank_image_file_name"
    t.string   "blank_image_content_type"
    t.integer  "blank_image_file_size"
    t.datetime "blank_image_updated_at"
    t.integer  "status"
    t.integer  "campaign_id"
    t.text     "customizable_options",        limit: 65535
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "category_id"
    t.string   "orientation"
    t.boolean  "customize",                                 default: true
    t.string   "static_pdf_file_name"
    t.string   "static_pdf_content_type"
    t.integer  "static_pdf_file_size"
    t.datetime "static_pdf_updated_at"
    t.text     "blank_image_meta",            limit: 65535
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "first_name",             default: "",     null: false
    t.string   "last_name",              default: "",     null: false
    t.string   "email",                  default: "",     null: false
    t.string   "zip_code"
    t.string   "department"
    t.string   "cell_phone"
    t.string   "council"
    t.string   "role",                   default: "User", null: false
    t.string   "local_number"
    t.boolean  "approved",               default: false
    t.boolean  "rejected",               default: false
    t.boolean  "receive_alerts",         default: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "affiliate_id"
    t.boolean  "custom_branding",        default: false
    t.datetime "approval_reminder_sent"
    t.string   "vetter_region"
    t.index ["affiliate_id"], name: "index_users_on_affiliate_id", using: :btree
    t.index ["approved"], name: "index_users_on_approved", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["rejected"], name: "index_users_on_rejected", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
