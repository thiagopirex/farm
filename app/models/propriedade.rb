class Propriedade < ApplicationRecord
  has_many :areas
  has_many :aguas
  has_many :malhaAguas
  validates_presence_of :nome, :message => " - Este campo deve ser preenchido!"
  
  def getGeoJsonFromRGeoPoint
      if !self.sede.nil?
        hash = RGeo::GeoJSON.encode(self.sede)
        geometry = {'type' => hash['type'], 'coordinates' => hash['coordinates']}
        propriedades = {}
        feature = {'type' => 'Feature', 'properties' => propriedades, 'geometry' => geometry}
        
        feature.to_json
      end
  end
  
  
  # TODO: alterar para consulta em banco
  #SELECT sum(u.qnt_animais)
  # FROM public.usos u
  # inner join public.areas a on a.id = u.area_id 
  # where u.dt_fim is null
  #   and a.propriedade_id = 1
    
  def getQntAnimais
    qnt = 0;
    self.areas.each do |a|
      a.usos.each do |u|
        if u.dt_fim.nil?
          qnt= qnt + u.total_animais;    
        end
      end
    end
    qnt;
  end
end
