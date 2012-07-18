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
  # also_reload '/path/to/some/file'
  # dont_reload '/path/to/other/file'
  end

# use Rack::Auth::Basic do |username, password|
#   username == 'admin' && password == 'zue7Eig6ahvo9aqu'
# end


  #     namespace '/blog' do
  #       get { haml :blog }
  #       get '/:entry_permalink' do
  #         @entry = Entry.find_by_permalink!(params[:entry_permalink])
  #         haml :entry
  #       end
  #
  #       # More blog routes...
  #     end

  get '/' do
    puts "Request #{Time.now}"
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

  get '/g' do
    "fsdfsdsd #{Time.now}"
  end

#   list = []
#
#   get '/' do
#     stream(:keep_open) do |out|
#       list << out
#       out.callback { list.delete out }
#       out.errback do
#         logger.warn "lost connection"
#         list.delete out
#       end
#     end
#   end

end
