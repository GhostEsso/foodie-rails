module Admin
  class SessionsController < ApplicationController
    layout 'admin'

    ADMIN_CREDENTIALS = {
      email: 'admin@foody.fr',
      password: 'admin123!'
    }

    helper_method :admin_signed_in?

    def new
      redirect_to admin_root_path if admin_signed_in?
    end

    def create
      if params[:email] == ADMIN_CREDENTIALS[:email] && params[:password] == ADMIN_CREDENTIALS[:password]
        session[:admin_signed_in] = true
        redirect_to admin_root_path, notice: 'Connexion réussie!'
      else
        flash.now[:alert] = 'Email ou mot de passe incorrect.'
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:admin_signed_in] = false
      redirect_to admin_login_path, notice: 'Déconnexion réussie!'
    end

    private

    def admin_signed_in?
      session[:admin_signed_in] == true
    end
  end
end 