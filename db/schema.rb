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

ActiveRecord::Schema.define(version: 20210605190141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "nome"
    t.string "situacao"
    t.geometry "limites", limit: {:srid=>3857, :type=>"st_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "propriedade_id"
    t.string "pastagem_atual"
    t.binary "foto_conteudo"
    t.string "foto_tipo"
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
    t.string "nome"
    t.integer "nirf"
    t.geometry "sede", limit: {:srid=>3857, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usos", force: :cascade do |t|
    t.date "dt_inicio"
    t.date "dt_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "area_id"
    t.integer "qnt_macho_faixa_um"
    t.integer "qnt_macho_faixa_dois"
    t.integer "qnt_macho_faixa_tres"
    t.integer "qnt_femea_faixa_um"
    t.integer "qnt_femea_faixa_dois"
    t.integer "qnt_femea_faixa_tres"
    t.index ["area_id"], name: "index_usos_on_area_id"
  end

  add_foreign_key "acaos", "areas"
  add_foreign_key "analises", "areas"
  add_foreign_key "areas", "propriedades"
  add_foreign_key "malha_aguas", "propriedades"
  add_foreign_key "usos", "areas"
end
