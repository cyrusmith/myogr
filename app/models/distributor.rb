class Distributor < ForumModels
  include Tenacity
  self.table_name = 'ibf_topics'
  self.primary_key = 'tid'

  has_many :product_orders, foreign_key: 'tid'

  def self.in_distribution_for_user(user_id)
    self.joins(:product_orders)
        .where('color = 5')
        .where(ProductOrder.table_name => {member_id: user_id, show_buyer: 1})
        .where('ibf_zakup.status NOT IN (-2, 2)')
        .group(self.primary_key)
  end

  def user_participate? (user_id)
    Distributor.joins(:product_orders).where(tid: self.tid, ProductOrder.table_name => {member_id: user_id}).count > 0
  end

  def organizer
    User.find(self.starter_id).try(:display_name)
  end

  def remove_from_cabinet(user_id)
    self.product_orders.showing.for_user(user_id).each do |order|
      order.show_buyer = 0
      order.save!
    end
  end
end