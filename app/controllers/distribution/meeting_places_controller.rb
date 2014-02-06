module Distribution
  class MeetingPlacesController < AdminController

    def index
      @meeting_places = MeetingPlace.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @meeting_places }
      end
    end

    def show
      @meeting_place = MeetingPlace.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @meeting_place }
      end
    end

    def new
      @meeting_place = MeetingPlace.new
      @meeting_place.build_location

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @meeting_place }
      end
    end

    def edit
      @meeting_place = MeetingPlace.find(params[:id])
    end

    def create
      @meeting_place = MeetingPlace.new(params[:distribution_meeting_place])

      respond_to do |format|
        if @meeting_place.save
          format.html { redirect_to distribution_meeting_places_path, notice: 'Address was successfully created.' }
          format.json { render json: @meeting_place, status: :created, location: @meeting_place }
        else
          format.html { render action: 'new' }
          format.json { render json: @meeting_place.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @meeting_place = MeetingPlace.find(params[:id])

      respond_to do |format|
        if @meeting_place.update_attributes(params[:distribution_meeting_place])
          format.html { redirect_to distribution_meeting_places_path, notice: 'Address was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @meeting_place.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @meeting_place = MeetingPlace.find(params[:id])
      @meeting_place.destroy

      respond_to do |format|
        format.html { redirect_to distribution_meeting_places_path }
        format.json { head :no_content }
      end
    end
  end
end
