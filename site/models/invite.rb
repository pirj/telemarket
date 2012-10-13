class Invite
  include DataMapper::Resource
  property :id, Serial

  belongs_to :identity

  property :code, String, :length => 40
  property :discharged, Boolean, :default => false
end
