source 'https://rubygems.org'

# Web server
gem 'thin'
gem 'eventmachine', '~> 1.0.0'
gem 'rack-fiber_pool'

# Web framework
gem 'sinatra'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'sinatra-can', :require => 'sinatra/can'
gem 'rack-protection'
gem 'slim'
gem 'redis-rack', :require => 'rack/session/redis'

# Misc tools
gem 'cheers'
gem 'roo'
gem 'logging'

# Mail
gem 'mail'

# Database
gem 'pg'
gem 'datamapper'
%w(core sqlite-adapter postgres-adapter validations timestamps migrations constraints aggregates types pager is-tree).each do |g|
  gem 'dm-' + g
end
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'redis'
gem 'hiredis'
gem 'em-hiredis'

group :development do
  gem 'pry'
  gem 'pry-rescue'
end
