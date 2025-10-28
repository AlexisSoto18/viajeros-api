class Api::ReservationsController < ApplicationController
    before_action :authorize_request
  
    def index
      if current_user.admin?
        scope = Reservation.all
      elsif current_user.host?
        scope = Reservation.joins("LEFT JOIN places ON reservations.reservable_type='Place' AND reservations.reservable_id=places.id")
                           .joins("LEFT JOIN events ON reservations.reservable_type='Event' AND reservations.reservable_id=events.id")
                           .where("places.user_id = :uid OR events.user_id = :uid", uid: current_user.id)
      else
        scope = current_user.reservations
      end
      render json: scope.order(created_at: :desc)
    end
  
    def show
      r = Reservation.find(params[:id])
      # accesible por dueño de la reserva, dueño del recurso o admin
      if r.user_id == current_user.id || current_user.admin? || owner_of?(r)
        render json: r
      else
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end
  
    def create
      r = Reservation.new(res_params.merge(user_id: current_user.id, status: 'pending'))
      check_slots!(r)
      r.save!
      render json: r, status: :created
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  
    def accept
      authorize_host
      r = Reservation.find(params[:id])
      return render json: { error: 'Forbidden' }, status: :forbidden unless owner_of?(r) || current_user.admin?
      r.update!(status: 'accepted')
      decrement_slots!(r)
      render json: r
    end
  
    def reject
      authorize_host
      r = Reservation.find(params[:id])
      return render json: { error: 'Forbidden' }, status: :forbidden unless owner_of?(r) || current_user.admin?
      r.update!(status: 'rejected')
      render json: r
    end
  
    def cancel
      r = Reservation.find(params[:id])
      return render json: { error: 'Forbidden' }, status: :forbidden unless r.user_id == current_user.id || current_user.admin?
      r.update!(status: 'cancelled')
      render json: r
    end
  
    private
  
    def res_params
      params.permit(:reservable_type, :reservable_id, :quantity, :notes)
    end
  
    def check_slots!(r)
      resource = r.reservable_type.constantize.find(r.reservable_id)
      raise "Recurso no aprobado" unless resource.approved?
      available = resource.slots_available.to_i
      raise "No hay cupo suficiente" if r.quantity.to_i > available
    end
  
    def decrement_slots!(r)
      resource = r.reservable
      resource.update!(slots_available: resource.slots_available - r.quantity)
    end
  
    def owner_of?(r)
      res = r.reservable
      res.respond_to?(:user_id) && res.user_id == current_user.id
    end
  
    def authorize_host
      return if current_user&.host? || current_user&.admin?
      render json: { error: 'Forbidden' }, status: :forbidden and return
    end
  end
  