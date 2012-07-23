class TargetGroup
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  belongs_to :company
  has n, :targets

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
