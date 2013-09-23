class SessionsController < ApplicationController
  skip_before_filter :authentificate, :except => :destroy

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
