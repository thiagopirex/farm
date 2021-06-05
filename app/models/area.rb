class Area < ActiveRecord::Base
  belongs_to :propriedade
  has_many :analises
  has_many :usos, ->{order('dt_fim asc')}
  has_many :acaos, ->{order('dt_acao desc')}
  
  before_destroy :verificar_dependencias
  
  validate :file_size_under_five_mb, :file_type
  
  
  def verificar_dependencias
    if self.usos.any? or self.analises.any? or self.acaos.any?
      errors.add(:base, " Esta área não pode ser excluída pois há histórico de uso e/ou análises e/ou ações!")
      return false
    else
      return true
    end
  end
  
  def getGeoJsonFromRGeo
      if !self.limites.nil?
        hash = RGeo::GeoJSON.encode(self.limites)
        #@poligono = hash.to_json
        geometry = {'type' => hash['type'], 'coordinates' => hash['coordinates']}
        
        qnt = getDadosDeUso
        
        propriedades = {
          'nome' => self.nome, 
          'situacao' => self.situacao, 
          'animais' => qnt[0],
          'qntDiasComAnimais' => qnt[1],
          'pastagem' => self.pastagem_atual,
          'analises' => self.analises.count,
          'historico' => (self.updated_at).strftime('%d/%m/%Y  %H:%M')}
        feature = {'type' => 'Feature', 'properties' => propriedades, 'geometry' => geometry}
        
        hec = self.limites.area.to_d
        
        feature.to_json
      end
    end  
    
  def getDadosDeUso
    dados = [0,0]
    self.usos.each do |u|
      #uso em aberto (data fim nula)
      if u.dt_fim.nil?
        dados = [
          u.total_animais,
          (DateTime.now - u.dt_inicio).to_i
        ]
      end
    end
    dados
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
        errors.add(:file, 'A imagem não pode ser maior que 5 megabyte.')
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


