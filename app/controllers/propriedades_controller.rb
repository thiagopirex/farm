class PropriedadesController < BasicController
  before_action :set_propriedade, only: [:show, :edit, :update, :destroy]
  

  # GET /propriedades
  # GET /propriedades.json
  def index
    @propriedades = Propriedade.all
  end

  # GET /propriedades/1
  # GET /propriedades/1.json
  def show
    @sede_ponto = @propriedade.getGeoJsonFromRGeoPoint
  end

  # GET /propriedades/new
  def new
    @propriedade = Propriedade.new
  end

  # GET /propriedades/1/edit
  def edit
    @sede_ponto = @propriedade.getGeoJsonFromRGeoPoint
  end

  # POST /propriedades
  # POST /propriedades.json
  def create
    @propriedade = Propriedade.new(propriedade_params)
    @propriedade.sede = getRGeoFromGeoJson

    respond_to do |format|
      if @propriedade.save
        format.html { redirect_to @propriedade, notice: 'Propriedade criada com sucesso!' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /propriedades/1
  # PATCH/PUT /propriedades/1.json
  def update
    
    respond_to do |format|
      @atributos = propriedade_params.clone
      updateLocalizacao
      if @propriedade.update_attributes(@atributos)
        format.html { redirect_to @propriedade, notice: 'Propriedade atualizada com sucesso!' }
        format.json { render :show, status: :ok, location: @propriedade }
      else
        format.html { render :edit }
        format.json { render json: @propriedade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /propriedades/1
  # DELETE /propriedades/1.json
  def destroy
    @propriedade.destroy
    respond_to do |format|
      format.html { redirect_to propriedades_url, notice: 'Propriedade excluída!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_propriedade
      @propriedade = Propriedade.find(params[:id])
      @propriedades = Propriedade.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def propriedade_params
      params.require(:propriedade).permit(:nome, :nirf, :sede)
    end
    
    def updateLocalizacao
      valor = getRGeoFromGeoJson
      if !valor.nil?
        @atributos[:sede] = valor
      end
    end
    
    def getRGeoFromGeoJson
      #https://github.com/rgeo/rgeo-geojson
      p = params[:sede_ponto]
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
end
