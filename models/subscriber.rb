class Subscriber
  include DataMapper::Resource
  property :id, Serial

  property :email, String

  validates_presence_of      :email
  validates_format_of        :email, :with => :email_address
  validates_uniqueness_of    :email
end
