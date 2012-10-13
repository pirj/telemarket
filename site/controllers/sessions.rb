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

  post '/sessions/create' do
    identity = Identity.authenticate params[:auth_key], params[:password]
    unless identity
      flash[:error] = 'Неверные логин или пароль'
      redirect 'sessions/new'
    end
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
