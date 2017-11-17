class Agua < ActiveRecord::Base
  belongs_to :propriedade
  validate :file_size_under_five_mb, :file_type
  
  def getGeoJsonFromRGeoPoint
      if !self.localizacao.nil?
        hash = RGeo::GeoJSON.encode(self.localizacao)
        geometry = {'type' => hash['type'], 'coordinates' => hash['coordinates']}
        propriedades = {
          'tipo' => self.tipo 
        }
        feature = {'type' => 'Feature', 'properties' => propriedades, 'geometry' => geometry}
        
        # geos_wgs84_factory = RGeo::Geos.factory(srid: 3857, srs_database: srs_db)
        # geos_polygon = RGeo::Feature.cast(self.limites, geos_wgs84_factory)
        
        feature.to_json
      end
  end
  
  def getContentImgBase64
    if !self.foto_conteudo.nil?
      Base64.encode64(self.foto_conteudo).gsub("\n", '')
    end
  end


  def initialize(params = {})
    @file = params.delete(:file)
    super
    if @file
      self.foto_tipo = @file.content_type
      self.foto_conteudo = @file.read
    end
  end

  private

    NUM_BYTES_IN_MEGABYTE = 5242880
    def file_size_under_five_mb
      if !@file.nil? && (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
        # errors.add(:file, 'A imagem não pode ser maior que 5 megabyte.')
      end
    end
    def file_type
      if !@file.nil?
        type = @file.content_type
        if type != 'image/png' && type != 'image/jpeg' && type != 'image/jpg'
          #errors.add(:file, 'O arquivo tem que ser do tipo png, jpg ou jpeg.')
        end
      end
    end

end