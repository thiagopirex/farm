class CreateAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :areas do |t|
      t.string :nome, null: false
      t.string :situacao
      t.st_polygon :limites, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps null: false
    end
  end
end