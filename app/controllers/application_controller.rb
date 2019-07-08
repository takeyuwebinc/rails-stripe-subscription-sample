class ApplicationController < ActionController::Base
  helper_method :current_user

  private

    def authorize
      redirect_to new_session_path unless authorized?
    end

    def authorized?
      current_user.present?
    end

    def current_user
      User.find_by(id: session[:user_id])
    end
end
