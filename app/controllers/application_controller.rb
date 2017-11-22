class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :carregarMenu
  
  def carregarMenu
    @propriedades = Propriedade.all
  end
  
  private
    def logged_in?
      #true
      @current_usuario ||= session[:usuario_id]
    end
    
    helper_method :logged_in?

end
