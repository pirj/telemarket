class Plan
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  belongs_to :account
  has n, :target_groups
  has n, :calls

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
