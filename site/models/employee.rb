class Employee
  include DataMapper::Resource

  property :id,              Serial

  property :name, String

  belongs_to :company
  belongs_to :identity

  property :deleted_at,      ParanoidDateTime
  timestamps :at
end
