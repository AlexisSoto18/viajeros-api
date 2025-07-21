class Api::SessionsController < ApplicationController
  def create
    user = User.find_for_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: { token:, user: { id: user.id, email: user.email, role: user.role } }
    else
      render json: { error: "Credenciales inválidas" }, status: :unauthorized
    end
  end

  def validate
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base).first
      user = User.find(decoded["user_id"])
      render json: { valid: true, user: { id: user.id, email: user.email, role: user.role } }
    rescue
      render json: { valid: false }, status: :unauthorized
    end
  end
end
