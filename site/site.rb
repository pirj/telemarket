# coding: utf-8
require 'bundler'
require 'logger'
Bundler.require

require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?

class Site < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Namespace

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
  end

  enable :logging

  get '/' do
    logger.info "HA"
    slim :home
  end

  namespace '/live' do
    get '/' do
      stream do |out|
        begin
          loop do
            out << "#{Time.now} #{rand(1000)}<br/>"
            sleep rand 2
          end
        rescue IOError => e
          # closed
        end
      end
    end
  end

end
