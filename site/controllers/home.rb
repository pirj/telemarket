# coding: utf-8
class Site < Sinatra::Base
  get '/' do
    slim :'home/index', layout: :'home/layout'
  end

  get '/invite/:invite' do
    invite = params[:invite]


    session[:invited] = true
    flash['info'] = 'Вы были приглашены, воспользуйтесь регистрацией.'
    redirect '/'
  end
end
