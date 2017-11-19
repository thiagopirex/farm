class AreasController < ApplicationController
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  # GET /areas
  # GET /areas.json
  def index
    @propriedades = Propriedade.all
    if !params[:propriedade_id].nil?
      @propriedade = Propriedade.find(params[:propriedade_id])
      @areas = @propriedade.areas  
    else
      @areas = Area.all
    end
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    @area = Area.find(params[:id])
    @propriedade = @area.propriedade
    @analises = @area.analises
    @usos = @area.usos
    @acaos = @area.acaos
    @poligono = @area.getGeoJsonFromRGeo
    download = params[:download]
    if download
      send_data(@area.foto_conteudo,
                type: @area.foto_tipo,
                filename: "imagem")
    end
  end
  
  # GET /areas/new
  def new
    @area = Area.new
    @propriedade = Propriedade.find(params[:propriedade_id])
    @areas = @propriedade.areas
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
    @propriedade = @area.propriedade
    @areas = @propriedade.areas
    @poligono = @area.getGeoJsonFromRGeo
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)
    @area.limites = getRGeoFromGeoJson
    respond_to do |format|
      if @area.save
        
        #format.html { redirect_to areas_path(:propriedade_id => @propriedade.id), notice: 'Área criada com sucesso!' }
        format.html { redirect_to @area.propriedade, notice: 'Área criada com sucesso!' }
        format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    respond_to do |format|
      @atributos = area_params.clone
      file = @atributos.delete(:file)
      updateLimites
      if @area.update_attributes(@atributos)
        if file #ganbiarra para atualizar o arquivo
          if @area.update_attribute(:foto_conteudo, file.read) && @area.update_attribute(:foto_tipo, file.content_type)
            format.html { redirect_to @area.propriedade, notice: 'Área atualizada com sucesso!' }
            format.json { render :show, status: :ok, location: @area } 
          else
             response_error
          end
         else
          # response_ok
          format.html { redirect_to @area.propriedade, notice: 'Área atualizada com sucesso!' }
          format.json { render :show, status: :ok, location: @area } 
         end        
      else
        response_error
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @propriedade = @area.propriedade
    respond_to do |format|
      if @area.destroy
        format.html { redirect_to @propriedade, notice: 'Área excluída com sucesso!' }
      else
        @analises = @area.analises
        @usos = @area.usos
        @poligono = @area.getGeoJsonFromRGeo
        format.html { render :show }
      end
      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
      @propriedades = Propriedade.all
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params     
      params.require(:area).permit(:nome, :situacao, :propriedade_id, :limites, :pastagem_atual, :file)
    end
    
    def updateLimites
      valor = getRGeoFromGeoJson
      if !valor.nil?
        @atributos[:limites] = valor
      end
    end
    
    def getRGeoFromGeoJson
      #https://github.com/rgeo/rgeo-geojson
      p = params[:poligono]
      # geometria = RGeo::GeoJSON.decode(p, json_parser: :json)
      if p != "valor"
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
      format.json { render json: @area.errors, status: :unprocessable_entity }      
    end
    
    def response_ok
       format.html { redirect_to @area.propriedade, notice: 'Área atualizada com sucesso!' }
       format.json { render :show, status: :ok, location: @area }      
    end
end

