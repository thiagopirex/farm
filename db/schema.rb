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

ActiveRecord::Schema[8.0].define(version: 2025_09_05_184007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgis"

  create_table "acaos", force: :cascade do |t|
    t.string "nm_acao"
    t.date "dt_acao"
    t.decimal "vl_acao"
    t.string "ds_observacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "area_id"
    t.index ["area_id"], name: "index_acaos_on_area_id"
  end

  create_table "aguas", force: :cascade do |t|
    t.string "tipo"
    t.binary "foto_conteudo"
    t.string "foto_tipo"
    t.geometry "localizacao", limit: {:srid=>3857, :type=>"st_point"}
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "propriedade_id"
    t.index ["propriedade_id"], name: "index_aguas_on_propriedade_id"
  end

  create_table "analises", force: :cascade do |t|
    t.date "data"
    t.string "arquivo_nome"
    t.binary "arquivo_conteudo"
    t.string "arquivo_tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "area_id"
    t.index ["area_id"], name: "index_analises_on_area_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "nome", null: false
    t.string "situacao"
    t.geometry "limites", limit: {:srid=>3857, :type=>"st_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "propriedade_id"
    t.string "pastagem_atual"
    t.index ["propriedade_id"], name: "index_areas_on_propriedade_id"
  end

  create_table "malha_aguas", force: :cascade do |t|
    t.geometry "linha", limit: {:srid=>3857, :type=>"line_string"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "propriedade_id"
    t.index ["propriedade_id"], name: "index_malha_aguas_on_propriedade_id"
  end

  create_table "propriedades", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "nirf", null: false
    t.geometry "sede", limit: {:srid=>3857, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nirf"], name: "index_propriedades_on_nirf", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "usos", force: :cascade do |t|
    t.date "dt_inicio"
    t.date "dt_fim"
    t.integer "qnt_animais"
    t.string "idade_animais"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "area_id"
    t.index ["area_id"], name: "index_usos_on_area_id"
  end

  add_foreign_key "acaos", "areas"
  add_foreign_key "analises", "areas"
  add_foreign_key "areas", "propriedades"
  add_foreign_key "malha_aguas", "propriedades"
  add_foreign_key "sessions", "users"
  add_foreign_key "usos", "areas"
end
