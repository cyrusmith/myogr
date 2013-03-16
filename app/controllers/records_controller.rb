class RecordsController < AuthorizedController
  # GET /records
  # GET /records.json
  def index
    @records = current_user.records

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @records }
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    @record = Record.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/new
  # GET /records/new.json
  def new
    @record = Record.new
    @start_time = Time.parse Admin::Salon::Settings.schedule.mon.from
    @end_time = Time.parse Admin::Salon::Settings.schedule.mon.till
    @time_range = @start_time.split_by 30.minutes, @end_time
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/1/edit
  def edit
    @record = Record.find(params[:id])
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(params[:record])
    @record.record_time = Time.parse (params[:record][:full_time])
    # ?????
    @record.employee = choose_employee params[:record][:group] if params[:record][:employee] == 'any'
    current_user.records << @record

    respond_to do |format|
      if @record.save
        format.html { redirect_to records_path, notice: 'Record was successfully created.' }
        format.json { render json: @record, status: :created, location: @record }
      else
        format.html { render action: "new" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO Создать механизм выбора мастера
  def choose_employee group
    Admin::Salon::Employee.where(specialization: group).first.id
  end

  # PUT /records/1
  # PUT /records/1.json
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end

  def create_step1
    @record = Record.new
    @groups = Admin::Salon::Procedure.possible_groups
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @record }
    end
  end

  def create_step2
    @record = Record.new
    @procedures = Admin::Salon::Procedure.where(:group => params[:group])
    @employees = Admin::Salon::Employee.where(:specialization => params[:group])
    @start_time = Time.parse Admin::Salon::Settings.schedule.mon.from
    @end_time = Time.parse Admin::Salon::Settings.schedule.mon.till
    @time_range = @start_time.split_by 30.minutes, @end_time
    @group = params[:group]
    #@avaliable_time = get_avaliable_time(Time.today, 'any')
  end

  def get_avaliable_time_remote
    @start_time = Time.parse Admin::Salon::Settings.schedule.mon.from
    @end_time = Time.parse Admin::Salon::Settings.schedule.mon.till
    @time_range = @start_time.split_by 30.minutes, @end_time
    employee = Admin::Salon::Employee.find(params[:employee])

    render :json => employee.avaliable_time(params[:date]).map { |time| Russian::strftime(time, '%H%M') }.to_json
  end

end
