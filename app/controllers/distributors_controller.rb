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


    @user_orders = @distributor.product_orders.for_user(current_user.id).participate unless @distributor.nil?

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
    distributor.product_orders.showing.for_user(current_user.id).each do |order|
      order.show_buyer = 0
      order.save!
    end
  end
end
