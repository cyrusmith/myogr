# coding: utf-8
module Distribution
  class OrdersController < ApplicationController
    def index
      #@distributors = Distributor.owned_by current_user.id
      @distributors = Distributor.owned_by current_user.id
      @unused_barcodes = Barcode.unused current_user

      query_string = "SELECT zak.zid, zak.tid, zak.member_id, topics.title, users.members_display_name
                      FROM ibf_zakup zak
                      LEFT JOIN ibf_topics topics ON topics.`tid`=zak.`tid`
                      LEFT JOIN ibf_members users ON users.`id`=zak.`member_id`
                      WHERE zak.`status` NOT IN (-2, 2) AND topics.`color` != 6
                            AND topics.`starter_id`=#{current_user.id}"
      unless params[:users].nil?
        query_string << " AND zak.member_id IN (#{params[:users].join(',')})"
      end
      unless params[:distributors].nil?
        filter_value = params[:distributors]
        #@distributors = @distributors.where { tid.in filter_value }
        query_string << " AND zak.tid IN (#{filter_value.join(',')})"
      end

      query_string << ' GROUP BY zak.tid, zak.member_id ORDER BY users.members_display_name, zak.tid'
      @orders = ActiveRecord::Base.establish_connection(:ogromno).connection.select_all(query_string)
      @paginated_orders = Kaminari.paginate_array(@orders).page(params[:page] && 1).per(25)
      @orders.instance_eval <<-EVAL
      def current_page
        #{params[:page] || 1}
      end
      def num_pages
        count
      end
      def limit_value
        25
      end
      def total_count
        self.size
      end
      def total_pages
        (total_count.to_f / limit_value).ceil
      end
      EVAL
      ActiveRecord::Base.establish_connection
      @users = User.where(id: @orders.uniq { |order| order['member_id'] }.map { |order| order['member_id'] }).order('members_display_name')
      #@orders = @orders.page(params[:page].nil? ? 1 : params[:page])
      respond_to do |format|
        format.html
        format.json {render json: @orders}
        format.js
      end
    end

    def send_to_distrbution
      if (params[:user] && params[:distributor] && params[:barcode])
        #TODO обрабатывать заказы и привязывать к нему штрих-код в одной транзакции
        (0...(params[:user].length)).each do |i|
          user_id = params[:user][i]
          distributor = Distributor.find(params[:distributor][i])
          barcode_id = params[:barcode][i]
          order = PackageItem.create!(item_id: distributor.id, title: distributor.title,
                              organizer: User.find(distributor.starter_id).display_name, organizer_id: distributor.starter_id,
                              user_id: user_id)
          #TODO добавить проверку на свободность штрихкода
          order.barcode = Barcode.find(barcode_id)
          order.save
        end
      else
        redirect_to distribution_orders_path, flash: {alert: 'Вы не выбрали заказы для отправки в ЦР'}
      end
    end

  end
end
