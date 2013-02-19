class BannersController < AuthorizedController
  # GET /banners
  # GET /banners.json

  def index
    if current_user
      @banners = current_user.banners
      @accounts = Billing::Account.all
    else
      flash[:notice] = t "must_login"
      return redirect_to root_path
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @banners }
    end
  end

  # GET /banners/1
  # GET /banners/1.json
  def show
    @banner = Banner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @banner }
    end
  end

  # GET /banners/new
  # GET /banners/new.json
  def new
    @banner = Banner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @banner }
    end
  end

  # GET /banners/1/edit
  def edit
    @banner = Banner.find(params[:id])
    @promo_place = PromoPlace.find_by(:key => @banner[:type])
  end

  # POST /banners
  # POST /banners.json
  def create
    @banner = Factory::BannerFactory.new params[:banner][:type]
    @banner.update_attributes params[:banner]
    @banner.save
    current_user.banners << @banner

    respond_to do |format|
      if @banner.save
        format.html { redirect_to banners_path, notice: 'Banner was successfully created.' }
        format.json { render json: @banner, status: :created, location: @banner }
      else
        format.html { render action: "new" }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_step1
    @promo_places = PromoPlace.all
  end

  def create_step2
    @promo_place = PromoPlace.find_by(:key => params[:type])
    @banner = class_eval "#{params[:type]}.new"
  end

  # PUT /banners/1
  # PUT /banners/1.json
  def update
    @banner = Banner.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        format.html { redirect_to banners_path, notice: 'Banner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banners/1
  # DELETE /banners/1.json
  def destroy
    @banner = Banner.find(params[:id])
    @banner.deactivate if @banner.is_active
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to banners_url }
      format.json { head :no_content }
    end
  end

  def activate
    banner = Banner.find params[:id]
    if banner.is_active
      redirect_to banners_path, :alert => t("banner.already_activated")
    else
      banner.activate
      redirect_to banners_path
    end
  end

  def deactivate
    banner = Banner.find params[:id]
    unless banner.is_active
      redirect_to banners_path, :alert => t("banner.already_deactivated")
    else
      banner.deactivate
      redirect_to banners_path
    end
  end
end
