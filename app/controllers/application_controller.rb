class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :authentificate

  def current_user
    warden.user
  end

  def authentificate
    warden.authenticate(:cookie) unless warden.authenticated?
  end

end
