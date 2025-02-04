class DishesController < ApplicationController
  before_action :authenticate_user!, except: [ :home ]
  before_action :set_dish, only: [ :show, :edit, :update ]
  before_action :ensure_owner!, only: [ :edit, :update ]

  def home
    redirect_to dishes_path if user_signed_in?
  end

  def index
    @per_page = 6
    @page = [ params[:page].to_i, 1 ].max
    @total_dishes = Dish.count
    @total_pages = [ @total_dishes.to_f / @per_page, 1 ].max.ceil

    @dishes = Dish.includes(:bookings, user: { apartment: :building })
                 .with_attached_photos
                 .order(created_at: :desc)
                 .offset((@page - 1) * @per_page)
                 .limit(@per_page)

    if request.xhr?
      render partial: "dishes_list", locals: { dishes: @dishes }
    end
  end

  def my_dishes
    @per_page = 6
    @page = [ params[:page].to_i, 1 ].max
    @total_dishes = current_user.dishes.count
    @total_pages = [ @total_dishes.to_f / @per_page, 1 ].max.ceil

    @dishes = current_user.dishes
                        .includes(:bookings)
                        .with_attached_photos
                        .order(created_at: :desc)
                        .offset((@page - 1) * @per_page)
                        .limit(@per_page)

    if request.xhr?
      render partial: "dishes_list", locals: { dishes: @dishes }
    end
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
      redirect_to dishes_path, notice: "Votre plat a été ajouté avec succès!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @dish.update(dish_params)
      redirect_to @dish, notice: "Votre plat a été mis à jour avec succès!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def ensure_owner!
    unless @dish.user == current_user
      redirect_to dishes_path, alert: "Vous n'êtes pas autorisé à modifier ce plat."
    end
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :portions, :price, :ingredients, photos: [])
  end
end
