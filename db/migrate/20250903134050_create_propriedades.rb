class CreatePropriedades < ActiveRecord::Migration[8.0]
  def change
    create_table :propriedades do |t|
      t.string :nome, null: false
      t.integer :nirf, null: false
      t.st_point :sede, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps
    end
    add_index :propriedades, :nirf, unique: true
  end
end
