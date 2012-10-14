# coding: utf-8
class Site < Sinatra::Base

  # namespace '/live' do
  #   get do
  #     stream do |out|
  #       begin
  #         loop do
  #           out << "#{Time.now} #{rand(1000)}<br/>"
  #           sleep rand 2
  #         end
  #       rescue IOError => e
  #         # closed
  #       end
  #     end
  #   end
  # end

    # subscriber = EM::Hiredis.connect
    # subscriber.psubscribe '*'

    # stream :keep_open do |out|
    #   subscriber.on(:pmessage) do |key, channel, message|
    #     subscriber.punsubscribe '*' if out.closed?

    #     out << "#{key}, #{channel}, #{message}" unless out.closed?
    #   end
    # end

  get '/operator/register' do
    raise InviteRequired.new if session[:invite].nil?
    slim :'operator/register'
  end

  post '/operator/register' do
    raise InviteRequired.new if session[:invite].nil?
    identity = Identity.create email: params[:auth_key], password: params[:password], :role => 'operator', :name => params[:name]

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/operator'
  end

  get '/operator' do
    authorize! :list, :calls
    companies = Target.all(status: nil).company
    slim :'operator/index', locals: {companies: companies}
  end

  get '/operator/call/:company' do
    authorize! :make, :calls
    company = Company.get params[:company]
    slim :'operator/call', locals: {company: company}
  end
end
