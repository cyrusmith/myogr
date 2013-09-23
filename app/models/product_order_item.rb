class ProductOrderItem < Forum::Models
  self.table_name = 'ibf_zakup'
  self.primary_key = 'zid'
  paginates_per 50

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

  def self.orders_by_distributors(d)
    #self.participate.join{users}.join{distributors}.where{distributor.color.not_eq 6}.where{distributor.starter_id.eq 1273}.group{tid}.group{member_id}.order('ibf_members.members_display_name ASC').order('tid ASC')
    #self.participate.join{users}.where{tid.in distributors}.group(:tid, :member_id).order('members_display_name	ASC').order('tid DESC')
  end

  def customer
    User.find(self.member_id)
  end
end
