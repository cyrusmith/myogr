module Distribution
  class OrdersController < ApplicationController
    def index
      #@distributors = Distributor.owned current_user.id
      @distributors = Distributor.owned(1273)
      subquery = if params[:distributors].nil?
                   @distributors
                 else
                   filter_value = params[:distributors]
                   @distributors.where { tid.in filter_value }
                 end
      @orders = ProductOrder.orders_by_distributors(subquery)
      @users = User.where(id: @orders.all.uniq { |order| order.member_id }.map(&:member_id))
      unless params[:users].nil?
        users_value = params[:users]
        @orders = @orders.where { member_id.in users_value }
      end
      @unused_barcodes = Barcode.unused current_user
      @orders = @orders.page(params[:page].nil? ? 1 : params[:page])
    end
  end
end
