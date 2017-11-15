class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :carregarMenu
  
  def carregarMenu
    @propriedades = Propriedade.all
  end
end
