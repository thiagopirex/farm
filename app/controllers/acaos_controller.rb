class AcaosController < ApplicationController
  before_action :set_acao, only: [:show, :edit, :update, :destroy]
  
  
  # GET /acaos
  def index
    if !params[:area_id].nil?
      @area = Area.find(params[:area_id])
      @acaos = @area.acaos
    else
      @acaos = Acao.all
    end
  end

  # GET /acaos/1
  def show
  end

  # GET /acaos/new
  def new
    @acao = Acao.new
    @area = Area.find(params[:area_id])
    @acaos = @area.acaos
  end

  # GET /acaos/1/edit
  def edit
    @acao = Acao.find(params[:id])
    @area = @acao.area
    @acaos = @area.acaos
  end

  # POST /acaos
  def create
    @acao = Acao.new(acao_params)
    respond_to do |format|
      if @acao.save
        format.html { redirect_to @acao.area, notice: 'Execução adicionada com sucesso!' }
      else
        @area = @acao.area
        format.html { render :edit}
      end
    end
  end

  # PATCH/PUT /acaos/1
  def update
    respond_to do |format|
      @atributos = acao_params.clone
      if @acao.update_attributes(@atributos)
        format.html { redirect_to @acao.area, notice: 'Execução atualizada com sucesso!' }
      else
        @area = @acao.area
        format.html { render :edit }
      end
    end
  end

  # DELETE /acaos/1
  def destroy
    @acao.destroy
    respond_to do |format|
      format.html { redirect_to @acao.area, notice: 'Execução excluida com sucesso!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acao
      @acao = Acao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acao_params
      params.require(:acao).permit(:dt_acao, :nm_acao, :vl_acao, :ds_observacao, :area_id)
    end
end
