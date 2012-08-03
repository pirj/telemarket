# coding: utf-8
require 'bundler'
require 'logger'
Bundler.require

require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?

Dir['*.rb', 'models/*.rb'].each { |file| require File.join Dir.pwd, file }

class Site < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Namespace

  enable :sessions
  register Sinatra::Flash

  helpers Sinatra::ContentFor

  use Rack::Session::Cookie, :secret => 'paimoo4Odoo3FeWiovaiVi9iYi0PoceeHaesho3azeiy3aVuahri5Shibio6ohCh'
  use Rack::Protection

  enable :logging
  use Rack::CommonLogger #, Logger.new(STDOUT)

  use OmniAuth::Builder do
    provider :identity, :fields => [:email]
  end

  error OmniAuth::Error do
    403
  end

  [403, 404, 405, 500].each do |code|
    error code do
      slim "errors/#{code}.slim"
    end
  end

  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  DataMapper.finalize

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
    also_reload './models/*.rb'
  end

  not_found do
    'Не найдено.'
  end

  error do
    'Произошло нечто ужасное: ' + env['sinatra.error'].name
  end

  def current_user
    @current_user ||= Identity.get(session[:user_id]) if session[:user_id]
  end
end
