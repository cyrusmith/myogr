class Distributor < ForumModels
  include Tenacity

  self.table_name = 'ibf_topics'
  default_scope where(razdacha: true)

  has_one :user, foreign_key: 'starter_id'
end