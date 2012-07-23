# coding: utf-8
require 'bundler'
require 'logger'
Bundler.require

require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?

Dir['*.rb', 'models/*.rb'].each { |file| require File.join Dir.pwd, file }

class Site < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Namespace
  register Sinatra::Flash

  use Rack::Session::Pool
  use Rack::Protection

  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
    also_reload './models.rb'
  end

  enable :logging
  # enable :authentication

  set :sessions, true

  not_found do
    'Не найдено.'
  end

  error do
    'Произошло нечто ужасное: ' + env['sinatra.error'].name
  end

end
