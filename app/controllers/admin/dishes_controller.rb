module Admin
  class DishesController < Admin::BaseController
    def index
      @dishes = Dish.includes(:user).order(created_at: :desc)
    end

    def show
      @dish = Dish.find(params[:id])
    end

    def destroy
      @dish = Dish.find(params[:id])
      @dish.destroy
      redirect_to admin_dishes_path, notice: "Le plat a été supprimé avec succès."
    end
  end
end
