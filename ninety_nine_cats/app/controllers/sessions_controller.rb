class SessionsController < ApplicationController
  before_action :require_current_user!, only: [:new, :create]

  def new
    render :new
  end

  def create
    current_user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if current_user
      log_in!(current_user)

      flash[:success] = "Successfully logged in"
      redirect_to cats_url
    # else
    #   flash.now[:errors] = ["Bad auth credentials"]
    #   render :new
    end
  end

  def destroy
    log_out!
    flash[:success] = "Successfully logged out"
    redirect_to cats_url
  end

  def log_out!
    current_user.reset_session_token! if current_user

    self.session[:session_token] = nil
  end

end
