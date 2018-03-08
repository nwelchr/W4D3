class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :log_in!, :logged_in?, :current_user

  def require_current_user!
    redirect_to cats_url if logged_in?
  end

  def log_in!(user)
    #force other clients to log out by regenerating token
    user.reset_session_token!
    self.session[:session_token] = user.session_token
  end

  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def require_owner!
    # QUESTION
    # current_user == @cat.owner
    unless current_user.cats.include?(@cat)
      redirect_to cats_url
    end
  end

end
