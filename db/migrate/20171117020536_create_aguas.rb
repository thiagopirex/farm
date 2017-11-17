class CreateAguas < ActiveRecord::Migration[5.1]
  def change
    create_table :aguas do |t|
      t.string :tipo
      t.binary :foto_conteudo
      t.string :foto_tipo
      t.st_point :localizacao, :geometry => true, :srid => 3857 #SRID default do leaflet e googlemaps, openstreetmaps
      t.timestamps null: false
    end
  end
end
