class Identity
  include DataMapper::Resource
  include OmniAuth::Identity::Models::DataMapper

  attr_accessor :password_confirmation

  property :id,              Serial
  property :email,           String
  property :password_digest, Text

  property :role,            String

  has 1, :employee

  validates_presence_of      :email,    :role
  validates_format_of        :email,    :with => :email_address
  validates_format_of        :role,     :with => /[A-Za-z]/

  property :deleted_at,      ParanoidDateTime
  timestamps :at
end
