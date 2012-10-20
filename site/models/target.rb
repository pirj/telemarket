class Target
  include DataMapper::Resource
  property :id, Serial

  belongs_to :company

  property :name, String, :length => 128
  property :status, Boolean

  has n, :target_contacts, :constraint => :destroy

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
