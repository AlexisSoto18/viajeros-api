class Api::PlacesController < ApplicationController
  before_action :authorize_request
  before_action :set_pueblo, only: [ :index, :create ]
  before_action :set_place,  only: [ :show, :update, :destroy ]

  # GET /api/pueblo_magicos/:pueblo_magico_id/places?kind=restaurant
  def index
    scope = @pueblo.places
    scope = scope.where(kind: params[:kind]) if params[:kind].present?
    scope = (current_user&.admin? || current_user&.host?) ? scope : scope.where(approved: true)
    render json: scope.order(created_at: :desc)
  end

  # POST /api/pueblo_magicos/:pueblo_magico_id/places
  def create
    authorize_host
    place = @pueblo.places.new(place_params.merge(user_id: current_user.id, approved: false))
    if place.save
      render json: place, status: :created
    else
      render json: { errors: place.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @place.approved? || current_user&.admin? || @place.user_id == current_user&.id
      render json: @place
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  def update
    return render json: { error: "Forbidden" }, status: :forbidden unless current_user&.admin? || @place.user_id == current_user.id
    if @place.update(place_params)
      render json: @place
    else
      render json: { errors: @place.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "Forbidden" }, status: :forbidden unless current_user&.admin? || @place.user_id == current_user.id
    @place.destroy!
    head :no_content
  end

  private

  def set_pueblo
    @pueblo = PuebloMagico.find(params[:pueblo_magico_id])
  end

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:name, :kind, :description, :address, :lat, :lon,
    :slots_total, :slots_available, :opens_at, :closes_at, images: [])
  end
end
