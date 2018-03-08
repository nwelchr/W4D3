class UsersController < ApplicationController
  before_action :require_current_user!, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.new(user_params)

    if user.save
      log_in!(user)
      flash[:success] = "Welcome to Cat Land!"
      redirect_to cats_url
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
