class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @current_user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if @current_user
      log_in!(@current_user)

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
    @current_user.reset_session_token!
    self.session[session_token] = nil
  end

  def log_in!(user)
    #force other clients to log out by regenerating token
    user.reset_session_token!
    self.session[:session_token] = user.session_token
  end

end
