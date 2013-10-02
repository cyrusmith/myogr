module Distribution
  class ReportsController < ApplicationController
    def reception_summary
      point = Point.find(params[:point_id])
      output = ReceptionSummary.new(point, params[:group_num], view_context).to_pdf
      send_data output, :type => :pdf, :disposition => 'inline'
    end

    def reception_lists
      output = ReceptionLists.new(params[:group_num], view_context).to_pdf
      send_data output, :type => :pdf, :disposition => 'inline'
    end
  end
end
