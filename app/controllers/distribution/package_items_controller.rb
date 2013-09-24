module Distribution
  class PackageItemsController < Admin::AdminController

    def create
      if (params[:user] && params[:distributor] && params[:barcode])
        PackageItem.create_batch!(get_batched_params(params)) ? head(:created) : head(:unprocessable_entity)
      end
    end

    def update
      #TODO
    end

    private

    def get_batched_params(params)
      array_of_params = []
      (0...(params[:user].length)).each do |i|
        if params[:barcode][i].present?
          user_id = params[:user][i]
          distributor = Distributor.find(params[:distributor][i])
          barcode = Barcode.find(params[:barcode][i])
          array_of_params << {
              item_id: distributor.id,
              title: distributor.title,
              organizer: User.find(distributor.starter_id).display_name,
              organizer_id: distributor.starter_id,
              user_id: user_id,
              barcode: barcode
          }
        end
      end
      array_of_params
    end

  end
end