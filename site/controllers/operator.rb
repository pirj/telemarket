# coding: utf-8
class Site < Sinatra::Base

    # subscriber = EM::Hiredis.connect
    # subscriber.psubscribe '*'

    # stream :keep_open do |out|
    #   subscriber.on(:pmessage) do |key, channel, message|
    #     subscriber.punsubscribe '*' if out.closed?

    #     out << "#{key}, #{channel}, #{message}" unless out.closed?
    #   end
    # end

  get '/operator' do
    slim :'operator/index'
  end

  get '/operator/register' do
    slim :'operator/register'
  end

  post '/operator/register' do
    identity = Identity.create email: params[:auth_key], password: params[:password], password_confirmation: params[:password], :role => 'operator', :name => params[:name]

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/operator'
  end
end
