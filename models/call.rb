class Call
  include DataMapper::Resource
  property :id, Serial

  belongs_to :contact
  belongs_to :plan
  has 1, :operation

  property :result, Integer

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
