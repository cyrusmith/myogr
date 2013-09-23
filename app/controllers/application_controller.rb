# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :authentificate

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      not_found
    else
      redirect_to login_path, alert: 'Для доступа к данному разделу необходимо авторизироваться'
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_user
    warden.user
  end

  def authentificate
    warden.authenticate(:cookie) unless warden.authenticated?
  end

end
