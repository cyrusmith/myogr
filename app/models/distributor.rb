class Distributor < Forum::Models
  include Tenacity
  self.table_name = 'ibf_topics'
  self.primary_key = 'tid'

  has_many :product_order_items, foreign_key: 'tid'

  scope :owned_by, ->(owner_id) { where { (starter_id.eq owner_id) & (color > 1) & (color < 6) } }

  def title
    CGI.unescapeHTML(read_attribute :title)
  end

  def self.in_distribution_for_user(user_id)
    self.joins(:product_order_items)
    .where('color = 5')
    .where(ProductOrderItem.table_name => {member_id: user_id, show_buyer: 1})
    .where('ibf_zakup.status NOT IN (-2, 2)')
    .group(self.primary_key)
  end

  def user_participate? (user_id)
    Distributor.joins(:product_order_items).where(tid: self.tid, ProductOrderItem.table_name => {member_id: user_id}).count > 0
  end

  def organizer
    User.find(self.starter_id).try(:display_name)
  end

  def remove_from_cabinet(user_id)
    self.product_order_items.showing.for_user(user_id).each do |order|
      order.show_buyer = 0
      order.save!
    end
  end

  def link
    "#{::Settings.forum_url}/index.php?showtopic=#{self.id}"
  end
end