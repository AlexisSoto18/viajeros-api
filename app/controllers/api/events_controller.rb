class Api::EventsController < ApplicationController
    before_action :authorize_request
    before_action :set_pueblo, only: [:index, :create]
    before_action :set_event,  only: [:show, :update, :destroy]
  
    def index
      scope = @pueblo.events
      scope = (current_user&.admin? || current_user&.host?) ? scope : scope.where(approved: true)
      render json: scope.order(starts_at: :asc)
    end
  
    def create
      authorize_host
      event = @pueblo.events.new(event_params.merge(user_id: current_user.id, approved: false))
      if event.save
        render json: event, status: :created
      else
        render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      if @event.approved? || current_user&.admin? || @event.user_id == current_user&.id
        render json: @event
      else
        render json: { error: 'Not found' }, status: :not_found
      end
    end
  
    def update
      return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin? || @event.user_id == current_user.id
      if @event.update(event_params)
        render json: @event
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin? || @event.user_id == current_user.id
      @event.destroy!
      head :no_content
    end
  
    private
    def set_pueblo = @pueblo = PuebloMagico.find(params[:pueblo_magico_id])
    def set_event  = @event  = Event.find(params[:id])
  
    def event_params
      params.require(:event).permit(:title, :description, :location, :starts_at, :ends_at,
                                    :slots_total, :slots_available, images: [])
    end
  
    def authorize_host
      return if current_user&.host? || current_user&.admin?
      render json: { error: 'Forbidden' }, status: :forbidden and return
    end
  end
  