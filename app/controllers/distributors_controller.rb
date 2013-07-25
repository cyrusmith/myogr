class DistributorsController < ApplicationController
  # GET /Distributors
  # GET /Distributors.json
  def index
    @distributors = Distributor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @distributors }
    end
  end

  # GET /Distributors/1
  # GET /Distributors/1.json
  def show
    @distributor = begin
                     Distributor.find(params[:id])
                   rescue ActiveRecord::RecordNotFound
                     nil
                   end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @distributor }
      format.js
    end
  end

  # GET /Distributors/new
  # GET /Distributors/new.json
  def new
    @distributor = Distributor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @distributor }
    end
  end

  # POST /Distributors
  # POST /Distributors.json
  def create
    @distributor = Distributor.new(params[:distributors])

    respond_to do |format|
      if @distributor.save
        format.html { redirect_to @distributor, notice: 'Distributor was successfully created.' }
        format.json { render json: @distributor, status: :created, location: @distributor }
      else
        format.html { render action: "new" }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove
    @tid = params[:tid]
    distributor = Distributor.find @tid
    distributor.remove_from_cabinet current_user.id
  end

  def unfinished_orders
    customers = ProductOrder.where(tid: params[:id]).participate.group(:member_id).map{|order| order.member_id} - Distribution::PackageItem.where(item_id:params[:id]).in_distribution.map{|order| order.user_id}
    result = customers.map do |customer|
      user = User.find(customer)
      [user.id, user.members_l_display_name]
    end
    render json: result.to_json
  end
end
