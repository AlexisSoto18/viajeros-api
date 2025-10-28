class ApplicationController < ActionController::API
  private

  def authorize_request
    header = request.headers['Authorization']
    token  = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized and return
    end
  end

  def current_user
    @current_user
  end

  def authorize_admin
    return if current_user&.admin?
    render json: { error: 'Forbidden' }, status: :forbidden and return
  end

  def authorize_host
    return if current_user&.host? || current_user&.admin?
    render json: { error: 'Forbidden' }, status: :forbidden and return
  end
end
