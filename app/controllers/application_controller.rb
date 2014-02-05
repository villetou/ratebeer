class ApplicationController < ActionController::Base
  protect_from_forgery

  #määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user

  def ensure_that_is_admin
    redirect_to :back, notice:'you should be an admin to do that' unless current_user.admin
  end

  def ensure_that_signed_in 
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def current_user
  	return nil if session[:user_id].nil?
  	User.find(session[:user_id])
  end
end
