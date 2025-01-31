class RegistrationsController < ApplicationController
  def new
    @buildings = Building.all
  end

  def create
    @buildings = Building.all
    @user = User.new(user_params)
    
    if @user.save
      # Créer l'appartement pour l'utilisateur
      @user.create_apartment(
        building_id: params[:building_id],
        number: params[:apartment]
      )
      
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Compte créé avec succès !'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:full_name, :email, :password)
  end
end
