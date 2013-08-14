module Distribution
  class OrdersController < ApplicationController
    def index
      #@distributors = Distributor.owned current_user.id
      @distributors = Distributor.owned(1273)
      @unused_barcodes = Barcode.unused current_user

      query_string = "SELECT zak.tid, zak.member_id, topics.title, users.members_display_name
                      FROM ibf_zakup zak
                      LEFT JOIN ibf_topics topics ON topics.`tid`=zak.`tid`
                      LEFT JOIN ibf_members users ON users.`id`=zak.`member_id`
                      WHERE zak.`status` NOT IN (-2, 2) AND topics.`color` != 6
                            AND topics.`starter_id`=#{1273}"
      unless params[:users].nil?
        query_string << " AND zak.member_id IN (#{params[:users].join(',')})"
      end
      unless params[:distributors].nil?
        filter_value = params[:distributors]
        @distributors = @distributors.where { tid.in filter_value }
        query_string << " AND zak.tid IN (#{filter_value.join(',')})"
      end

      query_string << ' GROUP BY zak.tid, zak.member_id ORDER BY users.members_display_name, zak.tid'
      @orders = ActiveRecord::Base.establish_connection(:ogromno).connection.select_all(query_string)
      @paginated_orders = Kaminari.paginate_array(@orders).page(params[:page]).per(10)
      @orders.instance_eval <<-EVAL
      def current_page
        #{params[:page] || 1}
      end
      def num_pages
        count
      end
      def limit_value
        10
      end
      def total_count
        self.size
      end
      def total_pages
        (total_count.to_f / limit_value).ceil
      end
      EVAL
      ActiveRecord::Base.establish_connection
      @users = User.where(id: @orders.uniq { |order| order['member_id'] }.map{|order| order['member_id']}).order('members_display_name')
      #@orders = @orders.page(params[:page].nil? ? 1 : params[:page])
    end
  end

  def send

  end
end
