class Company
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  has n, :identities, :constraint => :destroy
  has n, :plans, :constraint => :destroy
  has n, :target_groups, :constraint => :destroy

  has n, :operations, :constraint => :destroy
  property :balance, Float

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
