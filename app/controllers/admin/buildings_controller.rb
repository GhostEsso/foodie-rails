module Admin
  class BuildingsController < Admin::BaseController
    def index
      @buildings = Building.all.order(created_at: :desc)
    end

    def new
      @building = Building.new
    end

    def create
      @building = Building.new(building_params)
      
      if @building.save
        redirect_to admin_buildings_path, notice: "Immeuble créé avec succès."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @building = Building.find(params[:id])
    end

    def update
      @building = Building.find(params[:id])
      
      if @building.update(building_params)
        redirect_to admin_buildings_path, notice: "Immeuble mis à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @building = Building.find(params[:id])
      @building.destroy
      
      redirect_to admin_buildings_path, notice: "Immeuble supprimé avec succès.", status: :see_other
    end

    private

    def building_params
      params.require(:building).permit(:name, :address)
    end
  end
end 