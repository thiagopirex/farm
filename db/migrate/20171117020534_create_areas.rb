class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|
      t.string :nome
      t.string :situacao
      t.st_polygon :limites, :geometry => true, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps null: false
    end
  end
end