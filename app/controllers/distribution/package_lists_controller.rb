#encoding: utf-8
module Distribution
  class PackageListsController < AdminController

    skip_authorize_resource :only => [:find_package, :days_info]

    # GET /package_lists
    # GET /package_lists.json
    def index
      @point = Point.find(params[:point_id])
      @package_lists = @point.package_lists.includes(:schedule)
      @search_data = SearchObject.new(params[:search])

      if params[:search]
        conditions = []

        conditions << [:where, schedule: {is_day_off: false}] unless @search_data.show_day_off
        conditions << [:where, schedule: {date: @search_data.date}] if @search_data.date
        if @search_data.states
          conditions << [:where, state: @search_data.states]
        else
          conditions << [:where, '`distribution_package_lists`.`state` not in ("archived")']
        end
        @package_lists = conditions.inject(@package_lists) { |obj, method_and_args| obj.send(*method_and_args) }
      end

      @package_lists = @package_lists.order { schedule.date.asc }.order { schedule.till.asc }.page params[:page]
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @package_lists }
      end
    end

    # GET /package_lists/1
    # GET /package_lists/1.json
    def show
      @point = Point.find(params[:point_id])
      @package_lists = if params[:id].present?
                         PackageList.find(params[:id])
                       elsif params[:date].present?
                         date = Date.parse params[:date]
                         package_list = @point.package_lists.includes(:schedule).where(schedule: {date: date})
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
      @point = Point.find(params[:point_id])
      @package_list = @point.package_lists.new
      @package_list.appointments.build
      @meeting_places_options = MeetingPlace.all.collect{|place| [place.location.street, place.id]}

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @package_list }
      end
    end

    # GET /package_lists/1/edit
    def edit
      @point = Point.find(params[:point_id])
      @package_list = PackageList.find(params[:id])
      @meeting_places_options = MeetingPlace.all.collect{|place| [place.location.street, place.id]}
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @package_list }
        format.js
      end
    end

    # POST /package_lists
    # POST /package_lists.json
    def create
      @point = Point.find(params[:point_id])
      list_hours = params[:date]
      @package_list = @point.package_lists.new(params[:package_list])
      list_date = @package_list.date.to_datetime
      @package_list.till = list_date.change hour: list_hours[:till].to_i
      @package_list.from = list_date.change hour: list_hours[:from].to_i

      respond_to do |format|
        if @package_list.save
          format.html { redirect_to distribution_point_package_lists_path(@point), notice: 'Package list was successfully created.' }
          format.json { render json: @package_list, status: :created, location: @package_list }
        else
          format.html { render action: 'new' }
          format.json { render json: @package_list.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /package_lists/1
    # PUT /package_lists/1.json
    def update
      @point = Point.find(params[:point_id])
      @package_list = PackageList.find(params[:id])
      list_hours = params[:date]
      list_date = @package_list.date.to_datetime
      @package_list.till = list_date.change hour: list_hours[:till].to_i
      @package_list.from = list_date.change hour: list_hours[:from].to_i
      respond_to do |format|
        if @package_list.update_attributes(params[:package_list])
          format.html { redirect_to distribution_point_package_lists_path(@point), notice: 'Package list was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
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

    #TODO Исправить на запрос.
    def find_package
      point = Point.find(params[:point_id])
      @available_packages = []
      point.package_lists.each do |list|
        formatted_date = list.date.strftime('%d%m%Y')
        if formatted_date.scan(params[:term]).length > 0
          list.packages.each do |package|
            @available_packages += [{label: formatted_date + '/' + package.code.to_s, value: package.id}]
          end
        end
      end
      render json: @available_packages.sort_by { |a| a[:label] }
    end

    def packages
      package_list = PackageList.find(params[:package_list_id])
      @packages = if (params[:state])
                    case params[:state]
                      when 'for_issue'
                        package_list.packages.in_states(:collected, :in_distribution).asc(:order).all
                      when
                      package_list.packages.in_states(params[:state]).asc(:order).all
                    end
                  else
                    package_list.packages.asc(:order).all
                  end
      render json: @packages
    end

    def days_info
      @point = Point.find(params[:point_id])
      marked_days = @point.get_days_info(current_user.case_active?, params)
      active_record = current_user.packages.select(&:active?).first
      if !active_record.nil? and active_record.package_list.point == @point
        marked_days << {active_record.package_list.date => 'active-record'}
      end
      render json: marked_days
    end

    def switch_day_off
      @point = Point.find(params[:point_id])
      date = Date.parse params[:date]
      @package_list = @point.package_lists.includes(:schedule).where(schedule: {date: date}).first
      if @package_list.day_off?
        @package_list.is_day_off = false
      else
        @package_list.is_day_off = true
      end
      respond_to do |format|
        if @package_list.save
          format.js { render 'show' }
        end
      end
    end

    def change_limit
      @point = Point.find(params[:point_id])
      date = Date.parse params[:date]
      @package_list = @point.package_lists.includes(:schedule).where(schedule: {date: date}).first
      @package_list = @point.package_lists.create(date: date) unless @package_list
      if params[:new_limit].present? and params[:new_limit].to_i >= @package_list.packages.count
        @package_list.update_attribute :package_limit, params[:new_limit]
      end
      render json: @package_list.package_limit
    end

    def fire_event
      @point = Point.find(params[:point_id])
      @package_list = PackageList.find(params[:id])
      event_name = params[:event].to_sym
      if @package_list.state_events.include? event_name
        respond_to do |format|
          if @package_list.fire_state_event(event_name)
            format.js { render 'new_state' }
          end
        end
      end
    end

    def packing_lists
      @package_list = PackageList.find(params[:package_list_id])
      output = PackingLists.new(@package_list, view_context).to_pdf
      filename = t('pdf.filemnames.packing_lists', date: Russian::strftime(@package_list.date, '%d.%m.%Y'))
      send_data output, :filename => filename,
                :type => :pdf, :disposition => 'inline'
    end

    def package_list_report
      @package_list = PackageList.find(params[:package_list_id])
      output = PackageListReport.new(@package_list, view_context).to_pdf
      filename = t('pdf.filemnames.package_lists', date: Russian::strftime(@package_list.date, '%d.%m.%Y'))
      send_data output, :filename => filename,
                :type => :pdf, :disposition => 'inline'
    end

    def print_collection_tags
      @package_list = PackageList.find(params[:package_list_id])
      output = CollectionTags.new(@package_list, view_context).to_pdf
      filename = t('pdf.filemnames.collection_tags', date: Russian::strftime(@package_list.date, '%d.%m.%Y'))
      send_data output, :filename => filename,
                :type => :pdf, :disposition => 'inline'
    end

    #отменить все нулевые записи
    def cancel_empty_packages
      @package_list = PackageList.find params[:id]
      @count = 0
      @package_list.packages.each do |package|
        is_empty = if @package_list.closed?
                     package.items.blank?
                   else
                     PackageItem.where(user_id: package.user_id, package_id: nil).accepted.blank?
                   end
        if is_empty && package.cancel
          @count = @count + 1
        end
      end
      respond_to do |format|
        format.js
      end
    end

  end

  class SearchObject

    attr_writer :hash

    POSSIBLE_STATES = [
        [I18n.t('distribution.package_lists.states.forming'), :forming],
        [I18n.t('distribution.package_lists.states.collecting'), :collecting],
        [I18n.t('distribution.package_lists.states.distributing'), :distributing],
        [I18n.t('distribution.package_lists.states.archived'), :archived],
    ]

    def initialize(hash)
      @hash = hash || {}
    end

    def date
      Date.parse(@hash[:date]) if @hash[:date].present?
    end

    def show_day_off
      @hash[:show_day_off]
    end

    def states
      @hash[:states].presence
    end

  end
end