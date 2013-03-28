class Admin::PromoPlaceController < Admin::AdminController
  def index
    @promo_list = PromoPlace.all
  end

  def create
    @promo_place = PromoPlace.new(params[:promo_place])
    if @promo_place.save
      flash[:success] = "Success"
      redirect_to admin_promo_place_index_path
    else
      render 'new'
    end
  end

  def new
    @promo_place = PromoPlace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo_place }
    end
  end

  def edit

  end

  def show

  end

  def update
    if PromoPlace.find(params[:promo_place][:_id]).update_attributes(params[:promo_place])
      flash[:success] = "Success"
      redirect_to admin_promo_place_index_path
    else
      render 'edit'
    end
  end

  def destroy
    if PromoPlace.find(params[:id]).delete
      flash[:success] = "Success"
      redirect_to admin_promo_place_index_path
    else
      render 'edit'
    end
  end
end
