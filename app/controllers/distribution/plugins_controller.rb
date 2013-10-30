module Distribution
  class PluginsController < ApplicationController
    def reception_logger
      respond_to do |format|
        format.js
      end
    end

    def distributor_info
      respond_to do |format|
        @distributor = User.find(params[:id])
        @pending_items = PackageItem.joins(:barcode).where(organizer_id: @distributor.id).pending.order(Barcode.table_name + '.value')
        format.js
      end
    end

  end
end
