class AguasController < BasicController
  before_action :set_agua, only: [:show, :edit, :update, :destroy]

  # GET /aguas
  # GET /aguas.json
  def index
    if !params[:propriedade_id].nil?
      @propriedade = Propriedade.find(params[:propriedade_id])
      @aguas = @propriedade.aguas
    else
      @aguas = Agua.all
    end
  end

  # GET /aguas/1
  # GET /aguas/1.json
  def show
    send_data(@agua.foto_conteudo,
              type: @agua.foto_tipo,
              filename: "imagem")
  end

  # GET /aguas/new
  def new
    @agua = Agua.new
    @propriedade = Propriedade.find(params[:propriedade_id])
    @aguas = @propriedade.aguas
  end

  # GET /aguas/1/edit
  def edit
    @agua = Agua.find(params[:id])
    @propriedade = @agua.propriedade
    @aguas = @propriedade.aguas
    @localizacao_ponto = @agua.getGeoJsonFromRGeoPoint
  end

  # POST /aguas
  # POST /aguas.json
  def create
    @agua = Agua.new(agua_params)
    @agua.localizacao = getRGeoFromGeoJson
    respond_to do |format|
      if @agua.save
        format.html { redirect_to @agua.propriedade, notice: 'Ponto de Água criado com sucesso!' }
        format.json { render :show, status: :created, location: @agua }
      else
        format.html { render :new }
        format.json { render json: @agua.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aguas/1
  # PATCH/PUT /aguas/1.json
  def update
    respond_to do |format|
      @atributos = agua_params.clone
      file = @atributos.delete(:file)
      updateLocalizacao
      
      if @agua.update_attributes(@atributos)
        if file #ganbiarra para atualizar o arquivo
          if @agua.update_attribute(:foto_conteudo, file.read) && @agua.update_attribute(:foto_tipo, file.content_type)
            format.html { redirect_to @agua.propriedade, notice: 'Ponto de Água atualizado com sucesso!' }
            format.json { render :show, status: :ok, location: @agua }
          else
             response_error
          end
        else
          format.html { redirect_to @agua.propriedade, notice: 'Ponto de Água atualizado com sucesso!' }
          format.json { render :show, status: :ok, location: @agua }
        end        
      else
        response_error
      end
    end
  end

  # DELETE /aguas/1
  # DELETE /aguas/1.json
  def destroy
    @agua.destroy
    respond_to do |format|
      format.html { redirect_to @agua.propriedade, notice: 'Ponto de Água excluido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agua
      @agua = Agua.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agua_params
      params.require(:agua).permit(:tipo, :localizacao, :propriedade_id, :file)
    end
    
    def updateLocalizacao
      valor = getRGeoFromGeoJson
      if !valor.nil?
        @atributos[:localizacao] = valor
      end
    end
    
    def getRGeoFromGeoJson
      #https://github.com/rgeo/rgeo-geojson
      p = params[:localizacao_ponto]
      # geometria = RGeo::GeoJSON.decode(p, json_parser: :json)
      if p != "valor" && p != ""
        geo_factory = RGeo::Geographic.spherical_factory(srid: 3857)
        geometria = RGeo::GeoJSON.decode(p, geo_factory: geo_factory, json_parser: :json)
        # g = geometria.geometry
        g = geometria.geometry
        logger.debug "Tipo da geometria: #{g.geometry_type.type_name}"
        logger.debug "Geometria: #{g.as_text}"
        g
      end
    end
    
    def response_error
      format.html { render :edit }
      format.json { render json: @agua.errors, status: :unprocessable_entity }
    end
end

