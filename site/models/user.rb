require 'bcrypt'

class User
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

  # Properties
  property :id,               Serial
  property :email,            String, :length => 100
  # BCrypt gives you a 60 character string
  property :crypted_password, String, :length => 60
  property :role,             String

  property :deleted_at, ParanoidDateTime
  timestamps :at

  belongs_to :company

  # Validations
  validates_presence_of      :email, :role
  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_format_of        :email,    :with => :email_address
  validates_format_of        :role,     :with => /[A-Za-z]/

  # Callbacks
  before :save, :encrypt_password

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    user = first(:conditions => { :email => email }) if email.present?
    return false if crypted_password.nil?
    user && user.has_password?(password) ? user : nil rescue nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def encrypt_password
    logger.error "crypting password! #{password}"
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
    logger.error crypted_password
  end
end
