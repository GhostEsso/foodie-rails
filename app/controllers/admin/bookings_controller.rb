module Admin
  class BookingsController < Admin::BaseController
    def index
      @bookings = Booking.includes(:user, :dish).order(created_at: :desc)
    end

    def show
      @booking = Booking.find(params[:id])
    end

    def destroy
      @booking = Booking.find(params[:id])
      @booking.destroy
      redirect_to admin_bookings_path, notice: "La réservation a été supprimée avec succès."
    end
  end
end 