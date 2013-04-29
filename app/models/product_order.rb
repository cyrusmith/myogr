class ProductOrder < ForumModels
  self.table_name = 'ibf_zakup'
  self.primary_key = 'zid'

  attr_accessible :show_buyer, :member_id, :status

  belongs_to :distributor, foreign_key: 'tid'

  scope :showing, where(show_buyer: 1)
  scope :for_user, ->(user_id){ where(member_id: user_id) }
  scope :participate, where('`status` NOT IN (-2, 2)')
  scope :not_participate, where(status: [-2, 2])

  def self.in_distribution_for_user(user_id)
    self.joins(:distributor)
    .where('ibf_topics.color = 5')
    .where(member_id: user_id, show_buyer: 1)
    .where('`status` NOT IN (-2, 2)')
  end
end
