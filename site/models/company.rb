class Company
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :length => 128

  has n, :employees, :constraint => :destroy
  has n, :plans, :constraint => :destroy
  has n, :target_groups, :constraint => :destroy

  has n, :operations, :constraint => :destroy
  property :balance, Float, :default => 0

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
