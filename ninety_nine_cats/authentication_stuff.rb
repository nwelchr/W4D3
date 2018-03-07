# User authentication stuff

class User < ApplicationRecord
  # ...

  # validates :session_token, presence: true
  # after_initialize :ensure_session_token
  #
  # # def self.generate_session_token
  #   SecureRandom::urlsafe_base64(16)
  # end
  #
  # # ...
  #
  # def reset_session_token!
  #   self.session_token = self.class.generate_session_token
  #   self.save!
  #   self.session_token
  # end

  # private
  # def ensure_session_token
  #   self.session_token ||= self.class.generate_session_token
  # end
end

def current_user
  #fetches the user we've logged in as
  return nil if self.session[:session_token].nil?
  @current_user ||= User.find_by(session_token: self.session[:session_token])
end

def logged_in?
  !!current_user
end

def log_in!(user)
  #force other clients to log out by regenerating token
  user.reset_session_token!
  self.session[:session_token] = user.session_token
end

def log_out!
  current_user.reset_session_token!
  self.session[session_token] = nil
end

# Let's finally finish what we started: let's protect the users#show page so that only the user themselves can view their own show
def require_user! #applicationcontroller
  redirect_to new_session_url if current_user.nil?
end
before_action :require_current_user!, except: [:create, :new] #userscontroller
# def require_no_user!
#   redirect_to users_url if current_user
# end

def destroy
  log_out!
  flash[:success] = "Successfully logged out"
  redirect_to users_url
end

def create
  user = User.find_by_credentials(
    params[:user][:email],
    params[:user][:password]
  )
  if user
    log_in!(user)
    flash[:success] = "Successfully logged in"
    redirect_to user_url(user)
  else
    flash.now[:errors] = ["Bad auth credentials"]
    render :new
 end
end
