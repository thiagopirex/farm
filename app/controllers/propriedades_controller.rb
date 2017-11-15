class PropriedadesController < ApplicationController
  before_action :set_propriedade, only: [:show, :edit, :update, :destroy]

  # GET /propriedades
  # GET /propriedades.json
  def index
    @propriedades = Propriedade.all
  end

  # GET /propriedades/1
  # GET /propriedades/1.json
  def show
  end

  # GET /propriedades/new
  def new
    @propriedade = Propriedade.new
  end

  # GET /propriedades/1/edit
  def edit
  end

  # POST /propriedades
  # POST /propriedades.json
  def create
    @propriedade = Propriedade.new(propriedade_params)

    respond_to do |format|
      if @propriedade.save
        format.html { redirect_to @propriedade, notice: 'Propriedade was successfully created.' }
        format.json { render :show, status: :created, location: @propriedade }
      else
        format.html { render :new }
        format.json { render json: @propriedade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /propriedades/1
  # PATCH/PUT /propriedades/1.json
  def update
    respond_to do |format|
      if @propriedade.update(propriedade_params)
        format.html { redirect_to @propriedade, notice: 'Propriedade was successfully updated.' }
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
      format.html { redirect_to propriedades_url, notice: 'Propriedade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_propriedade
      @propriedade = Propriedade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def propriedade_params
      params.require(:propriedade).permit(:nome, :nirf, :sede)
    end
end
