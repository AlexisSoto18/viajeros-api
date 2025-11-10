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
    # Solo el dueño o el admin pueden editar
    return render json: { error: "Forbidden" }, status: :forbidden unless current_user&.admin? || @place.user_id == current_user.id

    # Si el usuario NO es admin, forzamos que se desapruebe
    if current_user&.host?
      @place.assign_attributes(place_params)
      @place.approved = false
    else
      @place.assign_attributes(place_params)
    end

    if @place.save
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

  def approve
    if @place.update(approved: true)
      render json: { message: "Lugar aprobado correctamente ✅", place: @place }, status: :ok
    else
      render json: { errors: @place.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/admin/places/:id/unapprove
  def unapprove
    if @place.update(approved: false)
      render json: { message: "Lugar desaprobado ❌", place: @place }, status: :ok
    else
      render json: { errors: @place.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def authorize_admin
    render json: { error: "Acceso no autorizado" }, status: :forbidden unless current_user&.admin?
  end

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
