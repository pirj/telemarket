class Target
  include DataMapper::Resource
  property :id, Serial

  belongs_to :company

  property :status, Boolean

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
