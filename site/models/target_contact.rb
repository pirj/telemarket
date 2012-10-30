class TargetContact
  include DataMapper::Resource
  property :id, Serial

  belongs_to :target

  property :ceo, Boolean, :default => false
  property :name, String, :length => 128
  property :phone, String, :length => 16

  property :status, DataMapper::Property::Enum[:not_called, :wrong_number, :not_interested, :success, :transferred], :default => :not_called

  property :result, String, :length => 256

  # Added by a call operator
  belongs_to :added_by_operator, 'Identity', :required => false

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
