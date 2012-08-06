class Contact
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128
  property :phone, String, :length => 128

  belongs_to :target
  has n, :calls

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
