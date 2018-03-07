class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if user
      # TODO: log_in!(user)
      user.reset_session_token!
      self.session[:session_token] = user.session_token

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
    current_user.reset_session_token!
    self.session[session_token] = nil
  end

end
