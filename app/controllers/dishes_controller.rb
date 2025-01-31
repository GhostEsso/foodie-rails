class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dish, only: [:show]

  def index
    @dishes = Dish.joins(user: :apartment)
                 .where(apartments: { building_id: current_user.apartment.building_id })
                 .where.not(user_id: current_user.id)
  end

  def show
    @is_owner = @dish.user == current_user
  end

  def new
    @dish = Dish.new
  end

  def create
    @dish = current_user.dishes.build(dish_params)
    
    if @dish.save
      redirect_to dishes_path, notice: 'Votre plat a été ajouté avec succès!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :portions, :price)
  end
end 