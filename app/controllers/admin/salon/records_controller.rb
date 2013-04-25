module Admin
  module Salon
    class Admin::Salon::RecordsController < RecordsController
      layout 'admin'
      # GET /records
      # GET /records.json
      def index
        records = Record.where(record_date: Date.today...(Date.today + 7))
        @weekSchedule = {}
        records.each do |record|
          if @weekSchedule.key?(record.record_date)
            @weekSchedule[record.record_date] = @weekSchedule[record.record_date] + [record]
          else
            @weekSchedule[record.record_date] = [record]
          end
        end
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @weekSchedule }
        end
      end
      
      def get_namespace
        return [:admin, :salon]
      end
      
    end
  end
end
