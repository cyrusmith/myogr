module Distribution
  class PointsController < Admin::AdminController
    # GET /distribution_centers
    # GET /distribution_centers.json
    def index
      @distribution_points = Point.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_points }
      end
    end

    # GET /distribution_centers/1
    # GET /distribution_centers/1.json
    def show
      @distribution_point = Point.find(params[:id])
      @calendar_days_info = @distribution_point.get_days_info(true, admin_access: true).inject Hash.new, :merge
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
          format.html { render action: 'new' }
          format.json { render json: @distribution_point.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution_centers/1
    # PUT /distribution_centers/1.json
    def update
      @distribution_point = Point.find(params[:id])
      respond_to do |format|
        if @distribution_point.update_attributes(params[:distribution_point])
          format.html { redirect_to @distribution_point, notice: 'Distribution center was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
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

    # Прием товара
    def reception
      @point = Point.find(params[:point_id])
      if params[:commit]
        recieved_from = params[:recieved_from]
        accepted_items = []
        params[:package_item_id].each do |package_item_id|
          package_item = PackageItem.find package_item_id
          if package_item.can_accept?
            package_item.location = @point.id
            package_item.recieved_from = recieved_from
            package_item.accept
            accepted_items << package_item
          else
            raise StandardError, 'Item reception failed'
          end
          output = ReceptionSummary.new(@point, accepted_items, view_context).to_pdf
          send_data output, :type => :pdf, :disposition => 'inline'
        end
      else
        render
      end
    end

    # Выбытие товара
    def issuance
      @point = Point.find(params[:point_id])
    end

    def collect_package
      if (params[:package_list])
        items = params[:collected_items].split(/ /).delete_if { |c| c.blank? }.uniq.map { |deb| Integer(deb) }
        package = Package.find(params[:package_list])
        package.collect! params[:collector].to_i, items
        package.save
        @list = package.package_list
      end
      @point = Point.find(params[:point_id])
      employee_ids = @point.employees << @point.head_user
      @employees = employee_ids.map { |id| User.find(id) }
      respond_to do |format|
        format.html # show.html.erb
        format.js
      end
    end

    def issue_package
      @point = Point.find(params[:point_id])
      if (params[:packages])
        package = Package.find(params[:packages])
        @list = package.package_list
        if package.to_issued then
          flash[:success] = t('notifications.state_change_complete', new_state: t('distribution.package.states.issued'))
        else
          flash[:error] = t('notifications.state_change_error', new_state: t('distribution.package.states.issued'))
        end
      end
    end

    def accept_items
      @point = Point.find(params[:point_id])

    end

  end
end