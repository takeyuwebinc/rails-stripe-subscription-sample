class SessionsController < ApplicationController
  before_action :redirect_to_root, if: :authorized?

  def new
    @user = User.new
  end

  def create
    # この例では、簡単のため認証は行いません。
    user_params = params.require(:user).permit(:name, :email)
    @user = User.where(email: user_params[:email]).first_or_initialize
    @user.name = user_params[:name]
    if @user.save
      authorize(@user)
      redirect_to_root
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def redirect_to_root
      redirect_to root_path
    end

    def authorize(user)
      session[:user_id] = user.id
    end
end
