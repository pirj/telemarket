class Target
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  belongs_to :target_group
  has n, :contacts

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
