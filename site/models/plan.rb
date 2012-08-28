class Plan
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128
  property :description, Text

  belongs_to :company
  has n, :target_groups, :through => Resource
  has n, :calls

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
