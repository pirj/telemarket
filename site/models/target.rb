class Target
  include DataMapper::Resource
  property :id, Serial

  belongs_to :company

  property :name, String, :length => 128
  property :phone, String, :length => 128

  property :status, Boolean
  property :result, String, :length => 256

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
