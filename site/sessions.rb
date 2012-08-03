# coding: utf-8
class Site < Sinatra::Base
  get '/sessions/new' do
    slim :'sessions/new'
  end

  get '/auth/:provider/callback' do
    identity = Identity.authenticate params[:auth_key], params[:password]
    return redirect 'sessions/new' unless identity
    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/'
  end

  get '/sessions/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  get '/register' do
    slim :'sessions/register'
  end

  post '/register' do
    company = Company.new name: params[:company]
    identity = Identity.create email: params[:auth_key], password: params[:password], password_confirmation: params[:password], company: company, :role => 'customer'
    puts company.errors.inspect, identity.errors.inspect
    redirect '/'
  end
end
