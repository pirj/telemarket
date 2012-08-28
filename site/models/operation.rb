class Operation
  include DataMapper::Resource
  property :id, Serial

  belongs_to :call
  belongs_to :company

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
