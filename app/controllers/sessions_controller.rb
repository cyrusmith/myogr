class SessionsController < ApplicationController
  #def create
  #  login = params[:user][:login]
  #  #unless User.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
  #  #  forum_user = ForumUser.find(login)
  #  #  forum_user.valid_password? params[:user][:password]
  #  #end
  #  resource = warden.authenticate!(auth_options)
  #  set_flash_message(:notice, :signed_in) if is_navigational_format?
  #  sign_in(resource_name, resource)
  #  respond_with resource, :location => root_path
  #      #after_sign_in_path_for(resource)
  #end

  def new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!
    redirect_to root_url, notice: t('login_success')
  end

  def destroy
    warden.logout
    redirect_to root_url, notice: t('logout_success')
  end

end
