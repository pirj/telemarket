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

  post '/subscribe' do
    subscriber = Subscriber.create(email: params[:email])
    email = params[:email]

    Mail.new do
      from     'info@gotelemarket.com'
      to       email
      subject  'Телемаркет'
 
      html_part do
        content_type 'text/html; charset=UTF-8'
        body     "Вы подписались на новости проекта и первым узнаете, когда регистрация будет открыта."
      end
    end.deliver

    flash['error'] = subscriber.errors.values.join('. ') unless subscriber.errors.empty?
    flash['info'] = "Вы подписались на новости проекта и первым узнаете, когда регистрация будет открыта" if subscriber.errors.empty?
    redirect '/'
  end
end
