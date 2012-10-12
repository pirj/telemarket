# coding: utf-8
class Site < Sinatra::Base
  get '/sessions/new' do
    if current_user.nil?
      slim :'sessions/new'
    elsif current_user.company
      redirect '/company'
    else
      redirect '/operator'
    end
  end

  get '/auth/:provider/callback' do
    identity = Identity.authenticate({:email => params[:auth_key]}, params[:password])
    return redirect 'sessions/new' unless identity
    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    if identity.company.nil?
      redirect '/operator'
    else
      redirect '/company'
    end
  end

  get '/sessions/logout' do
    session[:user_id] = nil
    redirect '/'
  end
end
