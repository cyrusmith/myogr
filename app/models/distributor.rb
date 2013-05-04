class Distributor < ForumModels
  include Tenacity

  self.table_name = 'ibf_topics'
  self.primary_key = 'tid'
  #default_scope where('color > 1')

  has_many :product_orders, foreign_key: 'tid'

  def self.in_distribution_for_user(user_id)
    self.joins(:product_orders)
        .where('color = 5')
        .where(ProductOrder.table_name => {member_id: user_id, show_buyer: 1})
        .where('ibf_zakup.status NOT IN (-2, 2)')
  end

  def organizer
    self.starter_id
  end
end