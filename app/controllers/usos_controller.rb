class UsosController < BasicController
  before_action :set_uso, only: [:show, :edit, :update, :destroy]
  
  
  # GET /usos
  # GET /usos.json
  def index
    if !params[:area_id].nil?
      @area = Area.find(params[:area_id])
      @usos = @area.usos
    else
      @usos = Uso.all
    end
  end

  # GET /usos/1
  # GET /usos/1.json
  def show
  end

  # GET /usos/new
  def new
    @uso = Uso.new
    @area = Area.find(params[:area_id])
    @usos = @area.usos
  end

  # GET /usos/1/edit
  def edit
    @uso = Uso.find(params[:id])
    @area = @uso.area
    @usos = @area.usos
  end

  # POST /usos
  def create
    @uso = Uso.new(uso_params)
    @uso.validate
    respond_to do |format|
      if @uso.save
        format.html { redirect_to @uso.area, notice: 'Utilização adicionada com sucesso!' }
      else
        @area = @uso.area
        format.html { render :edit}
      end
    end
  end

  # PATCH/PUT /usos/1
  # PATCH/PUT /usos/1.json
  def update
    @uso.validate
    respond_to do |format|
      @atributos = uso_params.clone
      if @uso.update_attributes(@atributos)
        format.html { redirect_to @uso.area, notice: 'Utilização atualizada com sucesso!' }
      else
        @area = @uso.area
        format.html { render :edit }
      end
    end
  end

  # DELETE /usos/1
  # DELETE /usos/1.json
  def destroy
    @uso.destroy
    respond_to do |format|
      format.html { redirect_to @uso.area, notice: 'Utilização excluida com sucesso!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uso
      @uso = Uso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uso_params
      params.require(:uso).permit(:dt_inicio, :dt_fim, :qnt_animais, :idade_animais, :area_id)
    end
end
