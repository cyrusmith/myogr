# coding: utf-8
module Distribution
  class PackagesController < AuthorizedController

    before_filter :check_active_package, only: [:new, :create, :new_by_type]
    before_filter :check_changeability, only: [:edit, :update, :new_by_type]

    def index
      @distribution_packages = Package.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_packages }
      end
    end

    def find
      @package_sets = Package.joins(:package_list).joins(:items).where(package_list: {point_id: params[:point_id]}).in_states([:in_distribution, :collected])
      @package_sets = if params[:document_number]
                      package_set.where(document_number: params[:document_number])
                    else
                      package_set.where(user_id: params[:user_id])
                    end
    end

    def find_by_doc
      @packages = Package.order(:document_number).where('REPLACE(`document_number`, " ", "") like ?', "%#{params[:term]}%").in_distribution
      render json: @packages.map{|package| {id:package.document_number, text: package.document_number}}
    end

    # GET /distribution/packages/1
    # GET /distribution/packages/1.json
    def show
      @distribution_package = Package.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @distribution_package }
        format.js
      end
    end

    # GET /distribution/packages/new
    # GET /distribution/packages/new.json
    def new
      @package_form = PackageForm.new Package.new, current_user

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @distribution_package }
      end
    end

    # GET /distribution/packages/1/edit
    def edit
      @package = Package.find(params[:id])
      @package_form = PackageForm.new @package, current_user
      point_type = @package.package_list.point.type.demodulize.underscore.to_sym
      if point_type == :mobile_issue_point
        current_date = Date.parse('01-02-2014')
        end_date = current_date + MobileIssuePoint.record_time_duration
        # TODO добавить проверку на лимит записи, если у юзера нет кейса
        @appointments = Appointment.joins{package_list}.joins{package_list.schedule}.joins{package_list.point}.where{(package_list.schedules.date >= current_date) & (package_list.schedules.date <= end_date) & (package_list.state == 'forming') & (package_list.point.type == 'Distribution::MobileIssuePoint')}
        @appointments.all.reject! { |app| app.package_list.limit_filled? } unless current_user.case_active?
      end
      render point_type
    end

    # POST /distribution/packages
    # POST /distribution/packages.json
    def create
      @package = Package.new(params[:package])
      @package.user = current_user
      @package.distribution_method = :case if current_user.case_active?
      if (params[:package][:appointment_id])
        @package.package_list = Appointment.find(params[:package][:appointment_id]).package_list
      end
      respond_to do |format|
        if @package.save
          format.html { redirect_to root_path, flash: {success: "Вы успешно записались на #{Russian::strftime(@package.package_list.date, '%e %B')}"} }
          format.json { render json: @package, status: :created, location: @package }
        else
          #TODO
          @package_form = PackageForm.new @package, current_user, point: Point.new
          format.html { render action: 'new' }
          format.json { render json: @package.errors << @error_hash, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution/packages/1
    # PUT /distribution/packages/1.json
    def update
      @distribution_package = Package.find(params[:id])

      #distribution_point = Point.find(params[:distribution_point])
      #unless params[:package_date].blank?
      #  is_point_changed = !(@distribution_package.package_list.try(:point) == distribution_point)
      #  is_date_changed = !(@distribution_package.package_list.try(:date) == Date.parse(params[:package_date]))
      #  if is_point_changed or is_date_changed
      #    @distribution_package.package_list = distribution_point.package_lists.includes(:schedule).where(schedule: {date: params[:package_date]}).first
      #    @distribution_package.set_order
      #    message = "Запись успешно перенесена на #{I18n::l @distribution_package.package_list.date, format: :long} в центр раздач на #{@distribution_package.package_list.point.location.short_address}"
      #  end
      #end
      respond_to do |format|
        if @distribution_package.update_attributes(params[:package])
          format.html { redirect_to root_path, flash: {success: 'Запись сохранена успешно'} }
          format.json { head :no_content }
        else
          @package_form = PackageForm.new @distribution_package, current_user
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
        format.html { redirect_to root_path, flash: {success: 'Ваша запись была успешно аннулирована'} }
        format.json { head :no_content }
      end
    end

    def new_by_type
      @package_form = PackageForm.new Package.new, current_user
      if params[:point_type].to_sym == :mobile_issue_point
        current_date = Date.tomorrow
        end_date = current_date + MobileIssuePoint.record_time_duration
        # TODO добавить проверку на лимит записи, если у юзера нет кейса
        @appointments = Appointment.joins{package_list}.joins{package_list.schedule}.joins{package_list.point}.where{(package_list.schedules.date >= current_date) & (package_list.schedules.date <= end_date) & (package_list.state == 'forming') & (package_list.point.type == 'Distribution::MobileIssuePoint')}
        @appointments.all.reject! { |app| app.package_list.limit_filled? } unless current_user.case_active?
      end
      render params[:point_type]
    end

    private

    def check_active_package
      user_active_packages = current_user.packages.empty? ? Array.new() : current_user.packages.select { |p| p.active? }
      redirect_to edit_distribution_package_path(user_active_packages.first) if user_active_packages.count > 0
    end

    def check_changeability
      editing_package = Package.find(params[:id])
      redirect_to distribution_package_path(editing_package) unless editing_package.changeable?
    end

    def create_item_hash(distributor, is_next_time_pickup = false)
      distributor = Distributor.find distributor unless distributor.is_a? Distributor
      {
          item_id: distributor.tid,
          title: distributor.title,
          organizer: distributor.organizer,
          organizer_id: distributor.starter_id,
          is_next_time_pickup: is_next_time_pickup,
          state_on_creation: distributor.color,
          is_user_participate: distributor.user_participate?(current_user),
          user_id: current_user.id
      }
    end

    def validate_form
      @distribution_package.errors[:base] = t('distribution.package.errors.wrong_date_selected') if params[:package_date].blank?
      @distribution_package.errors[:base] = t('distribution.package.errors.distribution_point_not_selected') if params[:distribution_point].blank?
    end

    def no_errors?
      @distribution_package.errors.size == 0 && @distribution_package.valid?
    end

  end
end
