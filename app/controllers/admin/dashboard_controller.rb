module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_dishes = Dish.count
      @total_bookings = Booking.count
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_dishes = Dish.includes(:user).order(created_at: :desc).limit(5)
      @recent_bookings = Booking.includes(:user, :dish).order(created_at: :desc).limit(5)

      # Statistiques des réservations
      @pending_bookings = Booking.where(status: "pending").count
      @approved_bookings = Booking.where(status: "approved").count
      @rejected_bookings = Booking.where(status: "rejected").count

      # Statistiques des plats par utilisateur
      @top_cooks = User.joins(:dishes)
                      .group("users.id")
                      .select("users.*, COUNT(dishes.id) as dishes_count")
                      .order("dishes_count DESC")
                      .limit(5)
    end
  end
end
