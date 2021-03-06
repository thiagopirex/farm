class CreatePropriedades < ActiveRecord::Migration[5.1]
  def change
    enable_extension "postgis"
    create_table :propriedades do |t|
      t.string :nome
      t.integer :nirf
      t.st_point :sede, :geometry => true, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps
    end
  end
end
