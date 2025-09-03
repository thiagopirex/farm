class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login

  def require_login
    #if !logged_in?
    #    redirect_to login_path, notice: 'Autenticação obrigatória'
    #    return false
    #end
    return true
  end
end
