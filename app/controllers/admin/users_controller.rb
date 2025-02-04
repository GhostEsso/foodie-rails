module Admin
  class UsersController < Admin::BaseController
    def index
      @users = User.all.order(created_at: :desc)
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "L'utilisateur a été mis à jour avec succès."
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: "L'utilisateur a été supprimé avec succès."
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name)
    end
  end
end
