# coding: utf-8
module Distribution
  class PackagesController < AuthorizedController
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
    end

    # POST /distribution/packages
    # POST /distribution/packages.json
    def create
      @distribution_point = Point.find(params[:distribution_point])
      @package_list = @distribution_point.package_lists.find_or_create_by(date: params[:package_date])
      @distribution_package = @package_list.packages.new(params[:distribution_package])
      @distribution_package.user_id = current_user.id
      if params[:tid]
        params[:tid].uniq.each do |tid|
          @distribution_package.items.new(item_id: tid)
        end
      end

      respond_to do |format|
        if @distribution_package.save
          format.html { redirect_to distribution_packages_path, flash: {success: "Вы успешно записались!"} }
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

      respond_to do |format|
        if @distribution_package.update_attributes(params[:distribution_package])
          format.html { redirect_to @distribution_package, notice: 'Package was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @distribution_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /distribution/packages/1
    # DELETE /distribution/packages/1.json
    def destroy
      @distribution_package = Package.find(params[:id])
      @distribution_package.destroy

      respond_to do |format|
        format.html { redirect_to distribution_packages_url }
        format.json { head :no_content }
      end
    end
  end
end
