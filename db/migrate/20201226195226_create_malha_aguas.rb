class CreateMalhaAguas < ActiveRecord::Migration[5.1]
  def change
    create_table :malha_aguas do |t|
      t.line_string :linha, :geometry => true, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps
    end
  end
end
