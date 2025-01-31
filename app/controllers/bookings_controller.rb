class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:approve, :reject]
  before_action :ensure_owner, only: [:approve, :reject]

  def index
    @filter = params[:filter] || 'my_bookings'
    
    case @filter
    when 'pending'
      # Réservations en attente pour les plats de l'utilisateur
      @bookings = current_user.received_bookings.includes(dish: :user)
                            .where(status: 'pending')
                            .order(created_at: :desc)
    when 'received'
      # Réservations approuvées pour les plats de l'utilisateur
      @bookings = current_user.received_bookings.includes(dish: :user)
                            .where(status: 'approved')
                            .order(created_at: :desc)
    when 'my_bookings'
      # Toutes les réservations faites par l'utilisateur
      @bookings = current_user.bookings.includes(dish: :user)
                            .order(created_at: :desc)
    end
  end

  def create
    @dish = Dish.find(params[:dish_id])
    @booking = current_user.bookings.build(booking_params)
    @booking.dish = @dish
    @booking.status = 'pending'

    if @booking.save
      # Créer une notification pour le propriétaire du plat
      Notification.create(
        user: @dish.user,
        booking: @booking,
        message: "Nouvelle réservation pour votre plat #{@dish.name}",
        notification_type: 'new_booking'
      )
      redirect_to bookings_path, notice: 'Votre réservation a été envoyée et est en attente de confirmation.'
    else
      redirect_to dish_path(@dish), alert: 'Impossible de créer la réservation.'
    end
  end

  def approve
    if @booking.update(status: 'approved')
      # Créer une notification pour l'utilisateur qui a réservé
      Notification.create(
        user: @booking.user,
        booking: @booking,
        message: "Votre réservation pour #{@booking.dish.name} a été approuvée !",
        notification_type: 'booking_approved'
      )
      redirect_to bookings_path(filter: 'pending'), notice: 'Réservation approuvée.'
    else
      redirect_to bookings_path(filter: 'pending'), alert: 'Impossible d\'approuver la réservation.'
    end
  end

  def reject
    if @booking.update(status: 'rejected')
      # Créer une notification pour l'utilisateur qui a réservé
      Notification.create(
        user: @booking.user,
        booking: @booking,
        message: "Votre réservation pour #{@booking.dish.name} a été rejetée.",
        notification_type: 'booking_rejected'
      )
      redirect_to bookings_path(filter: 'pending'), notice: 'Réservation rejetée.'
    else
      redirect_to bookings_path(filter: 'pending'), alert: 'Impossible de rejeter la réservation.'
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:portions)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def ensure_owner
    unless @booking.dish.user == current_user
      redirect_to bookings_path, alert: 'Vous n\'êtes pas autorisé à effectuer cette action.'
    end
  end
end 