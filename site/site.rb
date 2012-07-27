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

  use Rack::Session::Cookie #, 'paimoo4Odoo3FeWiovaiVi9iYi0PoceeHaesho3azeiy3aVuahri5Shibio6ohCh'
  use Rack::Protection

  use Rack::CommonLogger

  use OmniAuth::Builder do
    provider :identity, :fields => [:email]
  end

  error OmniAuth::Error do
    403
  end

  [403, 404, 405, 500].each do |code|
    error code do
      slim "errors/#{code}"
    end
  end

  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
    also_reload './models/*.rb'
  end

  enable :logging
  set :sessions, true

  not_found do
    'Не найдено.'
  end

  error do
    'Произошло нечто ужасное: ' + env['sinatra.error'].name
  end
end
