class Identity
  include DataMapper::Resource
  include OmniAuth::Identity::Models::DataMapper

  attr_accessor :password_confirmation

  property :id,              Serial
  property :email,           String
  property :password_digest, Text

  property :role,            String

  validates_presence_of      :email,    :role
  validates_format_of        :email,    :with => :email_address
  validates_format_of        :role,     :with => /[A-Za-z]/

  belongs_to :company

  property :deleted_at,      ParanoidDateTime
  timestamps :at
end
