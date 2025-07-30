class Api::PuebloMagicosController < ApplicationController
  before_action :authorize_request
  before_action :set_pueblo_magico, only: [ :show, :update, :destroy ]
  before_action :authorize_admin, only: [ :create, :update, :destroy ]

  def index
    @pueblos = PuebloMagico.all
    render json: @pueblos
  end

  def show
    render json: @pueblo
  end

  def create
    @pueblo = PuebloMagico.new(pueblo_params)
    if @pueblo.save
      render json: @pueblo, status: :created
    else
      render json: { errors: @pueblo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @pueblo.update(pueblo_params)
      render json: @pueblo
    else
      render json: { errors: @pueblo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @pueblo.destroy
    head :no_content
  end

  private

  def set_pueblo_magico
    @pueblo = PuebloMagico.find(params[:id])
  end

  def pueblo_params
    params.require(:pueblo_magico).permit(:nombre, :region, :descripcion, :descripcion_corta, :latitud, :longitud, :poblacion, imagenes: [])
  end

  def authorize_admin
    render json: { error: "Acceso denegado" }, status: :unauthorized unless @current_user.role == "admin"
  end
end
