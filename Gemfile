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

# Mail
gem 'mail'

# Database
gem 'pg'
gem 'datamapper'
%w(core postgres-adapter validations timestamps migrations constraints aggregates types pager is-tree).each do |g|
  gem 'dm-' + g
end
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'redis'
gem 'hiredis'
gem 'em-hiredis'

# Misc dev tools
group :development do
  gem 'pry'
  gem 'dm-sqlite-adapter'
end
