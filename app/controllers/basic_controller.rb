class BasicController < ApplicationController
    before_action :require_login

  def require_login
    if !logged_in?
      redirect_to login_path, notice: 'Autenticação obrigatória'
      return false
    end
    true
  end
end
