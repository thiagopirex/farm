class SessionsController < ApplicationController
  def create
    usuario = ENV['LOGIN_USER']
    senha = ENV['LOGIN_PASSWORD']
    if params[:user] == usuario && params[:password] == senha
      session[:usuario_id] = 123
      redirect_to root_url
    else
      redirect_to login_path, alert: 'Usuário e/ou senha incorretos!'
    end
  end
  
  def destroy
    session[:usuario_id] = nil
    redirect_to login_path
  end
end
