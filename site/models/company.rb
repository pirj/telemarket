class Company
  include DataMapper::Resource
  property :id, Serial

  belongs_to :identity

  property :name, String, :length => 128

  property :instructions, Text
  property :manager_phone, String, :length => 16

  has n, :targets, :constraint => :destroy

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
