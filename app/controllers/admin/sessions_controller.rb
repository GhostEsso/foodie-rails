module Admin
  class SessionsController < ApplicationController
    layout "admin"

    # Utilisation des variables d'environnement pour les credentials
    def admin_credentials
      {
        email: ENV.fetch('ADMIN_EMAIL', 'admin@foody.fr'),
        password: ENV.fetch('ADMIN_PASSWORD', 'admin123!')
      }
    end

    helper_method :admin_signed_in?

    def new
      redirect_to admin_root_path if admin_signed_in?
    end

    def create
      if valid_admin_credentials?
        session[:admin_signed_in] = true
        redirect_to admin_root_path, notice: "Connexion réussie!"
      else
        flash.now[:alert] = "Email ou mot de passe incorrect."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:admin_signed_in] = false
      redirect_to admin_login_path, notice: "Déconnexion réussie!"
    end

    private

    def admin_signed_in?
      session[:admin_signed_in] == true
    end

    def valid_admin_credentials?
      params[:email] == admin_credentials[:email] &&
      params[:password] == admin_credentials[:password]
    end
  end
end
