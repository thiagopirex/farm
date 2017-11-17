class Propriedade < ApplicationRecord
  has_many :areas
  has_many :aguas
  validates_presence_of :nome, :message => " - Este campo deve ser preenchido!"
  
  def getGeoJsonFromRGeoPoint
      if !self.sede.nil?
        hash = RGeo::GeoJSON.encode(self.sede)
        geometry = {'type' => hash['type'], 'coordinates' => hash['coordinates']}
        propriedades = {}
        feature = {'type' => 'Feature', 'properties' => propriedades, 'geometry' => geometry}
        
        
        # geos_wgs84_factory = RGeo::Geos.factory(srid: 3857, srs_database: srs_db)
        # geos_polygon = RGeo::Feature.cast(self.limites, geos_wgs84_factory)
        
        feature.to_json
      end
  end
  
  def getQntAnimais
    qnt = 0;
    self.areas.each do |a|
      #TODO pegar valor da soma da última locação
      qnt= qnt + 1;
    end
    qnt;
  end
end
