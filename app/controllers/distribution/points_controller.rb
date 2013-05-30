module Distribution
  class PointsController < Admin::AdminController

    # GET /distribution_centers
    # GET /distribution_centers.json
    def index
      @distribution_centers = Point.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_centers }
      end
    end

    # GET /distribution_centers/1
    # GET /distribution_centers/1.json
    def show
      @distribution_point = Point.find(params[:id])
      @marked_days = @distribution_point.get_marked_days.inject Hash.new, :merge
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @distribution_point }
      end
    end

    # GET /distribution_centers/new
    # GET /distribution_centers/new.json
    def new
      @distribution_point = Point.new
      @distribution_point.address = Address.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @distribution_point }
      end
    end

    # GET /distribution_centers/1/edit
    def edit
      @distribution_point = Point.find(params[:id])
    end

    # POST /distribution_centers
    # POST /distribution_centers.json
    def create
      @distribution_point = Point.new(params[:distribution_point])
      respond_to do |format|
        if @distribution_point.save
          format.html { redirect_to distribution_points_path, notice: 'Distribution center was successfully created.' }
          format.json { render json: @distribution_point, status: :created, location: @distribution_point }
        else
          format.html { render action: "new" }
          format.json { render json: @distribution_point.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution_centers/1
    # PUT /distribution_centers/1.json
    def update
      @distribution_point = Point.find(params[:id])
      respond_to do |format|
        if @distribution_point.update_attributes(params[:distribution_center_distribution_center])
          format.html { redirect_to @distribution_point, notice: 'Distribution center was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @distribution_point.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /distribution_centers/1
    # DELETE /distribution_centers/1.json
    #TODO нужно запретить удаление ЦР, если в нем есть товар и записи
    def destroy
      @distribution_point = Point.find(params[:id])
      @distribution_point.destroy

      respond_to do |format|
        format.html { redirect_to distribution_points_url }
        format.json { head :no_content }
      end
    end

    def collect_package
      if (params[:package_list])
        items = params[:collected_items].split(/ /).delete_if { |c| c.blank? }.uniq.map {|deb| Integer(deb)}
        package = Package.find(params[:package_list])
        package.collect! Integer(params[:collector]), items
        package.save
      end
      @point = Point.find(params[:point_id])
      @employees_string = @point.employees.map{|id| id.to_s} <<  @point.head_user.to_s
      respond_to do |format|
        format.html # show.html.erb
        format.js
      end
    end
  end
end