# coding: utf-8
class Site < Sinatra::Base
  get '/sessions/new' do
    slim :'sessions/new'
  end

  get '/auth/:provider/callback' do
    identity = Identity.authenticate({:email => params[:auth_key]}, params[:password])
    return redirect 'sessions/new' unless identity
    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect identity.company.nil? ? '/operator' : '/company'
  end

  get '/sessions/logout' do
    session[:user_id] = nil
    redirect '/'
  end
end
