class Api::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      # render json: { token:, user: { id: user.id, email: user.email, role: user.role } }
      render json: {
        token:,
        user: {
          id: user.id,
          email: user.email,
          role: user.role,
          full_name: user.full_name
        }
      }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :role, :full_name,)
  end
end
