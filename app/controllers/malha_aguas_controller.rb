class MalhaAguasController < BasicController
  before_action :set_malha_agua, only: [:show, :edit, :update, :destroy]

  # GET /malha_aguas
  # GET /malha_aguas.json
  def index
    if !params[:propriedade_id].nil?
      @propriedade = Propriedade.find(params[:propriedade_id])
      @malha_aguas = @propriedade.malhaAguas
    else
      @malha_aguas = MalhaAgua.all
    end
  end

  # GET /malha_aguas/1
  # GET /malha_aguas/1.json
  def show
    if !params[:propriedade_id].nil?
      @propriedade = Propriedade.find(params[:propriedade_id])
      @malha_aguas = @propriedade.malhaAguas
    else
      @malha_aguas = MalhaAgua.all
    end
  end

  # GET /aguas/new
  def new
    @malha_agua = MalhaAgua.new
    @propriedade = Propriedade.find(params[:propriedade_id])
    @malha_aguas = @propriedade.malhaAguas
  end

  # GET /malha_aguas/1/edit
  def edit
    @malha_agua = MalhaAgua.find(params[:id])
    @linha = @malha_agua.getGeoJsonFromRGeoLine
    @propriedade = @malha_agua.propriedade
    @malha_aguas = @propriedade.malhaAguas
    
  end

  # POST /malha_aguas
  # POST /malha_aguas.json
  def create
    @malha_agua = MalhaAgua.new(malha_agua_params)
    @malha_agua.linha = getRGeoFromGeoJson
    respond_to do |format|
      if @malha_agua.save
        format.html { redirect_to @malha_agua.propriedade, notice: 'Curso de Água criado com sucesso!' }
        format.json { render :show, status: :created, location: @malha_agua }
      else
        format.html { render :new }
        format.json { render json: @malha_agua.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /malha_aguas/1
  # PATCH/PUT /malha_aguas/1.json
  def update
    respond_to do |format|
      @atributos = malha_agua_params.clone
      updateLinha
      
      if @malha_agua.update_attributes(@atributos)
          format.html { redirect_to @malha_agua.propriedade, notice: 'Curso de Água atualizado com sucesso!' }
          format.json { render :show, status: :ok, location: @malha_agua }      
      else
        response_error
      end
    end
  end

  # DELETE /malha_aguas/1
  # DELETE /malha_aguas/1.json
  def destroy
    @malha_agua.destroy
    respond_to do |format|
      format.html { redirect_to @malha_agua.propriedade, notice: 'Curso de Água excluido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_malha_agua
      @malha_agua = MalhaAgua.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def malha_agua_params
      params.require(:malha_agua).permit(:linha, :propriedade_id)
    end
    
    def updateLinha
      valor = getRGeoFromGeoJson
      if !valor.nil?
        @atributos[:linha] = valor
      end
    end
    
    def getRGeoFromGeoJson
      #https://github.com/rgeo/rgeo-geojson
      p = params[:linha]
      if p != "valor" && p != ""
        geo_factory = RGeo::Geographic.spherical_factory(srid: 3857)
        geometria = RGeo::GeoJSON.decode(p, geo_factory: geo_factory, json_parser: :json)
        g = geometria.geometry
        logger.debug "Tipo da geometria: #{g.geometry_type.type_name}"
        logger.debug "Geometria: #{g.as_text}"
        g
      end
    end
    
    def response_error
      format.html { render :edit }
      format.json { render json: @malha_agua.errors, status: :unprocessable_entity }
    end
end

