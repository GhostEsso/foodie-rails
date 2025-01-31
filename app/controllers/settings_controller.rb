class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if params[:user][:password].present?
      if @user.authenticate(params[:user][:current_password])
        if @user.update(password_params)
          redirect_to edit_settings_path, notice: "Mot de passe mis à jour avec succès."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "incorrect")
        render :edit, status: :unprocessable_entity
      end
    elsif params[:user][:avatar].present?
      if @user.update(avatar_params)
        redirect_to edit_settings_path, notice: "Photo de profil mise à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to edit_settings_path, alert: "Aucune modification effectuée."
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end 