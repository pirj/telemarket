class Company
  include DataMapper::Resource
  property :id, Serial

  belongs_to :identity

  property :name, String, :length => 128

  property :instructions, String

  has n, :targets, :constraint => :destroy

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
