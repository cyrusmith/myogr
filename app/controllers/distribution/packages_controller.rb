# coding: utf-8
module Distribution
  class PackagesController < ApplicationController
    # GET /distribution/packages
    # GET /distribution/packages.json
    def index
      @distribution_packages = current_user.packages

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_packages }
      end
    end

    # GET /distribution/packages/1
    # GET /distribution/packages/1.json
    def show
      @distribution_package = Package.find(params[:id])
      @found_items = @distribution_package.items
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @distribution_package }
      end
    end

    # GET /distribution/packages/new
    # GET /distribution/packages/new.json
    def new
      @distribution_package = Package.new
      @distribution_points = Point.all
      @found_items = Distributor.in_distribution_for_user current_user
      @marked_days = @distribution_points.first.get_marked_days.inject Hash.new, :merge unless @distribution_points.count == 0

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @distribution_package }
      end
    end

    # GET /distribution/packages/1/edit
    def edit
      @distribution_package = Package.find(params[:id])
      @distribution_points = Point.all
      already_added_items = @distribution_package.items
      already_added_items_ids = already_added_items.map(&:item_id)
      items_from_db = Distributor.in_distribution_for_user current_user
      @found_items = already_added_items.current_pickup + items_from_db.delete_if { |item| item.id.in? already_added_items_ids }
      @marked_days = @distribution_package.package_list.point.get_marked_days.inject Hash.new, :merge
      @marked_days[@distribution_package.package_list.date] = 'active-record'
    end

    # POST /distribution/packages
    # POST /distribution/packages.json
    def create
      @distribution_package.errors << t('distribution.package.errors.wrong_date_selected') unless params[:package_date]
      @distribution_point = Point.find(params[:distribution_point])
      @package_list = @distribution_point.package_lists.find_or_create_by(date: params[:package_date])
      @distribution_package = @package_list.packages.new(params[:distribution_package])
      @distribution_package.user_id = current_user.id
      @distribution_package.distribution_method = :case
      if params[:tid]
        current_pickup_ids = params[:tid].uniq.map(&:to_i)
        items_in_cabinet = Distributor.in_distribution_for_user current_user
        items_in_cabinet.each do |item|
          if item.tid.in?(current_pickup_ids)
            is_next_time_pickup = false
            current_pickup_ids.delete(item.tid)
          else
            is_next_time_pickup = true
          end
          @distribution_package.items.new(create_item_hash(item, is_next_time_pickup))
        end
        current_pickup_ids.each{|id| @distribution_package.items.new(create_item_hash(id))}
      end

      respond_to do |format|
        if @distribution_package.save
          format.html { redirect_to root_path, flash: {success: "Вы успешно записались на #{Russian::strftime(@distribution_package.package_list.date, '%e %B')}"} }
          format.json { render json: @distribution_package, status: :created, location: @distribution_package }
        else
          format.html { render action: "new" }
          format.json { render json: @distribution_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution/packages/1
    # PUT /distribution/packages/1.json
    def update
      @distribution_package = Package.find(params[:id])
      @distribution_package.errors << t('distribution.package.errors.wrong_date_selected') unless params[:package_date]
      distribution_point = Point.find(params[:distribution_point])
      if !(@distribution_package.package_list.point == distribution_point) or !(@distribution_package.package_list.date.eql? params[:package_date])
        @distribution_package.package_list = distribution_point.package_lists.find_or_create_by date: params[:package_date]
        @distribution_package.set_order
      end
      if params[:tid]
        existing_item_ids = {}
        @distribution_package.items.map{|item| existing_item_ids[item.item_id] = item.is_next_time_pickup}
        params[:tid].uniq.each do |tid|
          tid = tid.to_i
          if tid.in? existing_item_ids.keys
            #TODO оптимально не искать каждый раз объекты в таблице. Уменьшить количество запросов
            @distribution_package.items.where(item_id:tid).each{|item| item.is_next_time_pickup = false} if existing_item_ids[tid]
            existing_item_ids.delete(tid)
          else
            @distribution_package.items.new(create_item_hash(tid))
          end
        end
        existing_item_ids.keys.each {|id| @distribution_package.items.where(item_id: id).each{|item| item.is_next_time_pickup = true}}
      end
      respond_to do |format|
        if @distribution_package.errors.empty? and @distribution_package.update_attributes(params[:distribution_package])
          format.html { redirect_to root_path, flash: {success: "Данные по заявке #{Russian::strftime(@distribution_package.package_list.date, '%d%m%Y')}/#{@distribution_package.order} успешно обновлены" }}
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @distribution_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /distribution/packages/1
    # DELETE /distribution/packages/1.json
    def destroy
      @distribution_package = Package.find(params[:id])
      @distribution_package.delete

      respond_to do |format|
        format.html { redirect_to root_path, flash: {success: 'Ваша заявка была успешно аннулирована'} }
        format.json { head :no_content }
      end
    end

    private

    def create_item_hash(distributor, is_next_time_pickup = false)
      distributor = Distributor.find distributor unless distributor.is_a? Distributor
      { item_id: distributor.tid, title: distributor.title, organizer: distributor.starter_id, is_next_time_pickup: is_next_time_pickup, state_on_creation: distributor.color}
    end

  end
end
