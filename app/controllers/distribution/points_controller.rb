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

    def revision
      @point = Point.find(params[:point_id])
      @revision_barcodes = Barcode.where(owner: 0)
      if (params[:commit])
        (0...(params[:sender].length)).each do |i|
          sender_id = params[:sender][i]
          reciever_id = params[:reciever][i]
          barcode_id = params[:barcode][i]
          #TODO закупка
          order = PackageItem.create!(item_id: distributor.id, title: distributor.title,
                                      organizer: User.find(sender_id).display_name, organizer_id: sender_id,
                                      user_id: reciever_id)
          #TODO добавить проверку на свободность штрихкода
          order.barcode = Barcode.find(barcode_id)
          order.save
        end
      end
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
      if params[:commit]
        if params[:user_data] and params[:data_type]
          unsorted_items = if (params[:data_type] == :document)
                             packages = Package.where(document_number: params[:user_data]).active.all
                             users << packages.each(&:user_id)
                             result = []
                             users.each { |user| result << PackageItem.where(user_id: user).order('package_id DESC, is_next_time_pickup DESC').accepted }
                             result
                           else
                             @package_items = PackageItem.where(user_id: params[:user_data]).order('package_id DESC, is_next_time_pickup DESC').accepted
                           end
          @items_hash = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = Array.new } }
          unsorted_items.each do |item|
            if item.package_id.nil?
              (item.next_time_pickup? ? @items_hash[item.user_id][:later] : @items_hash[item.user_id][:new]) << item
            else
              @items_hash[item.user_id][item.package_id] << item
            end
          end
        else
          result = Distribution::ProcessorUtil.issue_package_items(params[:item_id])
          message = if result
                      {success: 'Закупки упешно выданы'}
                    else
                      {alert: 'Произошла ошибка при внесении изменений в базу данных! Попробуйте приозвести выдачу снова'}
                    end
          redirect_to distribution_point_issue_package_path(@point), flash: message
        end
      else
        render 'choose_recipient_form'
      end
    end

    def accept_items
      @point = Point.find(params[:point_id])
    end

  end
end