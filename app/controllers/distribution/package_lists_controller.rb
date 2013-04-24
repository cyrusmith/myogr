module Distribution
  class PackageListsController < ApplicationController
    # GET /package_lists
    # GET /package_lists.json
    def index
      @package_lists = PackageList.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @package_lists }
      end
    end

    # GET /package_lists/1
    # GET /package_lists/1.json
    def show
      @point = Point.find(params[:point_id])
      @package_list = if params[:id].present?
                        PackageList.find(params[:id])
                      elsif params[:date].present?
                        date = Date.parse params[:date]
                        package_list = @point.package_lists.where(date: date).first
                        if package_list.nil?
                          @point.package_lists.create(date: date, package_limit: @point.default_day_package_limit)
                        else
                          package_list
                        end
                      end
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @package_list }
        format.js
      end
    end

    # GET /package_lists/new
    # GET /package_lists/new.json
    def new
      @package_list = PackageList.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @package_list }
      end
    end

    # GET /package_lists/1/edit
    def edit
      @package_list = PackageList.find(params[:id])
    end

    # POST /package_lists
    # POST /package_lists.json
    def create
      @package_list = PackageList.new(params[:package_list])

      respond_to do |format|
        if @package_list.save
          format.html { redirect_to @package_list, notice: 'Package list was successfully created.' }
          format.json { render json: @package_list, status: :created, location: @package_list }
        else
          format.html { render action: "new" }
          format.json { render json: @package_list.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /package_lists/1
    # PUT /package_lists/1.json
    def update
      @package_list = PackageList.find(params[:id])

      respond_to do |format|
        if @package_list.update_attributes(params[:package_list])
          format.html { redirect_to @package_list, notice: 'Package list was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @package_list.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /package_lists/1
    # DELETE /package_lists/1.json
    def destroy
      @package_list = PackageList.find(params[:id])
      @package_list.destroy

      respond_to do |format|
        format.html { redirect_to package_lists_url }
        format.json { head :no_content }
      end
    end

    def days_off
      start_date = params[:start_date].blank? ? Date.today : params[:start_date]
      num_of_months = params[:num_months] ? params[:num_months].to_i.months : 2.month
      @package_lists = PackageList.where(:date.gte => start_date, :date.lte => start_date + num_of_months)
      render json: @package_lists.map(&:date)
    end

    def switch_day_off
      true
    end

  end
end