class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: :new

  def new; end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso."
    else
      flash.now[:alert] = "E-mail ou senha incorretos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Sessão encerrada."
  end

  private

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
