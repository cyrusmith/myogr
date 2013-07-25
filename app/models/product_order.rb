class ProductOrder < ForumModels
  self.table_name = 'ibf_zakup'
  self.primary_key = 'zid'

  attr_accessible :show_buyer, :member_id, :status

  belongs_to :distributor, foreign_key: 'tid'

  scope :showing, where(show_buyer: 1)
  scope :for_user, ->(user_id) { where(member_id: user_id) }
  scope :participate, where('`status` NOT IN (-2, 2)')
  scope :not_participate, where(status: [-2, 2])

  def self.in_distribution_for_user(user_id)
    self.joins(:distributor)
    .where('ibf_topics.color = 5')
    .where(member_id: user_id, show_buyer: 1)
    .where('`status` NOT IN (-2, 2)')
  end

  def self.active_orders_by_vendor(vendor_id)
    self
    .where('`status` NOT IN (-2, 2)')
    .where("`tid` IN (SELECT tid FROM `ibf_topics` WHERE color NOT IN (1,6) AND starter_id=#{1273})")
    .group(:tid, :member_id)
    .order('tid DESC').order('member_id ASC')
    #сделать сортировку по имени пользователя
  end

  def self.orders_by_distributors(distributors)
    self.participate.where{tid.in distributors}.group(:tid, :member_id).order('tid DESC').order('member_id ASC')
  end

  def customer
    User.find(self.member_id)
  end
end
