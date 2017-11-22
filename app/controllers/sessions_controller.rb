class SessionsController < ApplicationController
  def create
    usuario = ENV['user']
    senha = ENV['passwd']
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
