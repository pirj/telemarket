# coding: utf-8
class Site < Sinatra::Base
  get '/' do
    slim :'home/index', layout: :'home/layout'
  end

  get '/invite/:invite' do
    invite = Invite.first(:code => params[:invite])
    raise InviteRequired.new('Неверный код приглашения') if invite.nil?
    raise InviteRequired.new('Приглашение уже было использовано ранее') unless invite.invitee.nil?

    session[:invite] = params[:invite]
    flash['info'] = "Вы приглашены, воспользуйтесь регистрацией"
    redirect '/'
  end
end
