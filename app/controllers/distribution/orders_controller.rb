# coding: utf-8
module Distribution
  class OrdersController < ApplicationController
    authorize_resource class: false

    def index
      @package_items = []

      query_string = "SELECT zak.zid, zak.tid, zak.member_id, topics.title, users.members_display_name
                      FROM ibf_zakup zak
                      LEFT JOIN ibf_topics topics ON topics.`tid`=zak.`tid`
                      LEFT JOIN ibf_members users ON users.`id`=zak.`member_id`
                      WHERE zak.`status` NOT IN (-2, 2) AND topics.`color` != 6
                            AND topics.`starter_id`=#{current_user.id}"
      unless params[:distributor].nil?
        query_string << " AND zak.tid=#{params[:distributor]}"
        @package_items = PackageItem.joins(:barcode).where(item_id:params[:distributor])
      end


      query_string << ' GROUP BY zak.tid, zak.member_id ORDER BY users.members_display_name, zak.tid'
      @orders = Forum::Models.connection.select_all(query_string)
      respond_to do |format|
        format.json {render json: @orders}
        format.js
      end
    end

    def show
      @distributors = Distributor.owned_by current_user.id
      @unused_barcodes = Barcode.unused(current_user).order('value ASC')
    end

  end
end
