class TargetContact
  include DataMapper::Resource
  property :id, Serial

  belongs_to :target

  property :name, String, :length => 128
  property :phone, String, :length => 16

  property :status, Boolean
  property :result, String, :length => 256

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
