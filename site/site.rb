require 'bundler'
require 'logger'
Bundler.require

require 'sinatra/contrib'
require 'sinatra/streaming'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?

Dir['*.rb', 'models/*.rb', 'controllers/*.rb'].each { |file| require File.join Dir.pwd, file }

class Site < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Flash

  helpers Sinatra::ContentFor
  helpers Sinatra::Streaming

  use Rack::Session::Cookie, :secret => 'paimoo4Odoo3FeWiovaiVi9iYi0PoceeHaesho3azeiy3aVuahri5Shibio6ohCh'
  use Rack::Protection, except: :session_hijacking
  
  register Sinatra::Can

  enable :logging

  set :root, File.dirname(__FILE__)

  [401, 403, 404, 405, 500].each do |code|
    error code do
      slim :"errors/#{code}"
    end
  end

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.db")
  DataMapper.finalize
  # DataMapper.auto_upgrade!

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
    also_reload './models/*.rb'
    also_reload './controllers/*.rb'
  end

  def current_user
    @current_user ||= Identity.get(session[:user_id]) if session[:user_id]
  end
end
