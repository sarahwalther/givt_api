class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  private

    def authorize(user)
      user == auth_user || auth_user.type == "Admin" || render_unauthorized
    end

    def authenticate_admin
      authenticate_api_key && auth_user.type == "Admin" || render_unauthorized
    end

    def authenticate
      authenticate_api_key || render_unauthorized
    end

    def authenticate_api_key
      api_key = request.headers['X-Api-Key']
      @auth_user = User.find_by(api_key: api_key)
    end

    def auth_user
      @auth_user
    end

    def render_unauthorized
      render json: 'Bad credentials', status: 401
    end
end
