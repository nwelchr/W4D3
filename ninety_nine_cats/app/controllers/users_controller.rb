class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.new(user_params)

    if user.save
      flash[:success] = "Welcome to Cat Land!"
      redirect_to user_url(user)
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
