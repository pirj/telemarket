class Site < Sinatra::Base
  get '/company' do
    slim :'company/index'
  end
end
