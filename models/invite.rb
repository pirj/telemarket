class Invite
  include DataMapper::Resource
  property :id, Serial

  belongs_to :identity

  belongs_to :invitee, 'Identity', required: false

  property :code, String, length: 64

  before :create do |invite|
    invite.code = Digest::SHA2.hexdigest SecureRandom.random_bytes
  end
end
