class TargetGroup
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  belongs_to :company
  has n, :targets

  has n, :plans, :through => Resource

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
