class MalhaAgua < ApplicationRecord
    belongs_to :propriedade
    
    def getGeoJsonFromRGeoLine
      if !self.linha.nil?
        hash = RGeo::GeoJSON.encode(self.linha)
        #@poligono = hash.to_json
        geometry = {'type' => hash['type'], 'coordinates' => hash['coordinates']}
        
        feature = {'type' => 'Feature', 'geometry' => geometry}
        
        feature.to_json
      end
    end
end
