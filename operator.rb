class Site < Sinatra::Base
  get '/operator' do
    slim :'operator/index'
  end
end
