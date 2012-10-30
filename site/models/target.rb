class Target
  include DataMapper::Resource
  property :id, Serial

  belongs_to :company

  property :name, String, :length => 128
  property :status, DataMapper::Property::Enum[:in_process, :not_interested, :no_numbers, :success], :default => :in_process

  has n, :target_contacts, :constraint => :destroy

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
