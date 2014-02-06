# coding: utf-8
module Distribution
  class PointsController < AdminController
    # GET /distribution_centers
    # GET /distribution_centers.json
    def index
      @distribution_points = Point.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_points }
      end
    end

    # GET /distribution_centers/new
    # GET /distribution_centers/new.json
    def new
      @point = get_point_type.new(work_schedule: 1)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @point }
      end
    end

    # GET /distribution_centers/1/edit
    def edit
      @point = get_point_type.find(params[:id])
    end

    # POST /distribution_centers
    # POST /distribution_centers.json
    def create
      @point = get_point_type.new(params[:point])
      respond_to do |format|
        if @point.save
          format.html { redirect_to distribution_points_path, notice: 'Distribution center was successfully created.' }
          format.json { render json: @point, status: :created, location: @point }
        else
          format.html { render action: 'new' }
          format.json { render json: @point.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution_centers/1
    # PUT /distribution_centers/1.json
    def update
      @point = get_point_type.find(params[:id])
      respond_to do |format|
        if @point.update_attributes(params[:point])
          format.html { redirect_to @point, notice: 'Distribution center was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @point.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /distribution_centers/1
    # DELETE /distribution_centers/1.json
    #TODO нужно запретить удаление ЦР, если в нем есть товар и записи
    def destroy
      @point = Point.find(params[:id])
      @point.destroy

      respond_to do |format|
        format.html { redirect_to distribution_points_url }
        format.json { head :no_content }
      end
    end

    # Прием товара
    def reception
      @point = Point.find(params[:point_id])
    end

    def process_reception
      point = Point.find(params[:point_id])
      message = {alert: 'Проверьте правильность заполнения полей'}
      if params[:commit] && params[:package_item_id]
        recieved_from = params[:recieved_from]
        receiver = params[:receiver]
        accepted_items = []
        recieve_group_number = PackageItem.get_next_group_number
        withdraw_hash = {}
        params[:package_item_id].each do |package_item_id|
          package_item = PackageItem.find package_item_id
          if package_item.can_accept?
            withdraw_hash[package_item.org] ? withdraw_hash[package_item.org]=withdraw_hash[package_item.org]+1 : withdraw_hash[package_item.org] = 1
            package_item.location = point.id
            package_item.recieved_from = recieved_from
            package_item.receiver = receiver
            package_item.receiving_group_number = recieve_group_number
            package_item.not_conform_rules = params[:no_conform] if params[:no_conform].present?
            package_item.accept
            accepted_items << package_item
          else
            raise StandardError, 'Item reception failed'
          end
        end
        barcode_price = Distribution::Settings.barcode_price || 0
        withdraw_hash.each do |key, value|
          key.withdraw(barcode_price * value, 1, "Активация #{value} штрихкодов", :barcode)
        end
        message = {flash: {success: "Товар успешно принят. #{view_context.link_to 'Распечатать ведомость', distribution_reception_summary_path(point.id, recieve_group_number), target: '_blank'}. #{view_context.link_to 'Распечатать маркировочные листы', distribution_reception_lists_path(recieve_group_number), target: '_blank'}".html_safe}}
      end
      redirect_to distribution_point_reception_path(point), message
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
      if request.get?
        if params[:user_data] and params[:data_type]
          @items_hash = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = Array.new } }
          packages = case params[:data_type]
                       when 'document'
                         Package.where(document_number: params[:user_data]).active.all
                       when 'id', 'display_name'
                         user_id = params[:user_data].to_i
                         @items_hash[user_id] = {};
                         Package.where(user_id: user_id).active.all
                       else
                         Array.new
                     end
          packages.each do |package|
            @items_hash[package.user_id][package.id] = []
            package.items.select { |item| item.barcode }.each { |item| @items_hash[package.user_id][package.id] << item }
          end
          @items_hash.each_key do |user_id|
            @items_hash[user_id][:later] = PackageItem.where(user_id: user_id, is_next_time_pickup: true).accepted.all
            @items_hash[user_id][:new] = PackageItem.where(user_id: user_id, package_id: nil, is_next_time_pickup: false).accepted.all
          end
        else
          render 'distribution/points/choose_recipient_form'
        end
      elsif request.post?
        result = Distribution::ProcessorUtil.issue_package_items(params[:packages], params[:item_id])
        message = if result
                    {success: 'Закупки успешно выданы'}
                  else
                    {alert: 'Произошла ошибка при внесении изменений в базу данных! Попробуйте приозвести выдачу снова'}
                  end
        redirect_to distribution_point_issue_package_path(@point), flash: message
      else
        render 'distribution/points/choose_recipient_form'
      end
    end

    def get_point_type
      Point
    end

  end
end