class AnalisesController < ApplicationController
  before_action :set_analise, only: [:show, :edit, :update, :destroy]

  # GET /analises
  # GET /analises.json
  def index
    redirect_to areas_url
  end

  # GET /analises/1
  # GET /analises/1.json
  def show
    send_data(@analise.arquivo_conteudo,
              type: @analise.arquivo_tipo,
              filename: @analise.arquivo_nome)
  end

  # GET /analises/new
  def new
    @analise = Analise.new
    @area = Area.find(params[:area_id])
  end

  # GET /analises/1/edit
  def edit
    @area = Area.find(params[:area_id])
  end

  # POST /analises
  # POST /analises.json
  def create
    @analise = Analise.new(analise_params)
    @area = @analise.area
    respond_to do |format|
      if @analise.save
        format.html { redirect_to @area, notice: 'Análise criada com sucesso!' }
        format.json { render :show, status: :created, location: @analise }
      else
        format.html { render :new }
        format.json { render json: @analise.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /analises/1
  # DELETE /analises/1.json
  def destroy
    @area = @analise.area
    @analise.destroy
    respond_to do |format|
      format.html { redirect_to @area, notice: 'Análise excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analise
      @analise = Analise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def analise_params
      params.require(:analise).permit(:data, :area_id, :file)
    end
end
