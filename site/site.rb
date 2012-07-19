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
    also_reload './cons/*.rb'
  end

  enable :logging

end
