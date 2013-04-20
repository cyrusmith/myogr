class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    if current_user.present? and current_user.admin?
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      not_found
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    if current_user.present? and current_user.id == @user.id
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      not_found
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    not_found unless current_user.present? and current_user.id == @user.id
  end

  # GET /users/verify/:verification_code
  def verification
    respond_to do |format|
      if User.verify params[:verification_code], set_user_verified: true
        format.html { redirect_to root_path, flash: {success: t('user.verification_success')} }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { redirect_to root_path, alert: t('user.verification_failed') }
        format.json { render json: @user, status: :precondition_failed }
      end
    end
  end

  # render remind password form
  def remind
    if params[:user].present?
      user = User.where('lower(members_display_name) = :value OR lower(email) = :value', value: params[:user][:email]).first
      if user.present?
        user.generate_verification_data
        user.save
        UserMailer.password_recovery_mail(user).deliver
        redirect_to login_path, flash: {success: t('notifications.password_recovery_mail_sent')}
      else
        render 'remind', flash: {alert: t('notifications.wrong_credentials')}
      end
    else
      @user = User.new
    end
  end

  # check verification code for user and show new password form
  def recover_password
    @verification_code = params[:verification_code]
    @user = User.verify @verification_code
    redirect_to root_url unless @user
  end

  def set_new_password
    user = User.find_by_verification_code params[:user][:verification_code]
    respond_to do |format|
      if user.present?
        user.credential.converge_password = params[:user][:password]
        user.credential.save
        format.html { redirect_to login_path, flash: {success: t('notifications.new_password_success')} }
        format.json { render status: :accepted }
      else
        format.html { redirect_to remind, flash: {success: t('notifications.wrong_credentials')} }
        format.json { render status: :not_found }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        UserMailer.verification_email(@user).deliver
        format.html { redirect_to root_path, flash: {success: t('user.create_success')} }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, flash: {success: t('user.update_success')} }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def find
    @users = User.order(:members_l_display_name).where("members_l_display_name like ?", "%#{params[:term]}%")
    render json: @users.map(&:members_l_display_name)
  end
end
