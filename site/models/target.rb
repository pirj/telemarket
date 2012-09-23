class Target
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128
  property :phone, String, :length => 128

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
