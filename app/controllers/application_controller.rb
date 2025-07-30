class ApplicationController < ActionController::API
  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base).first
      @current_user = User.find(decoded["user_id"])
    rescue
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
