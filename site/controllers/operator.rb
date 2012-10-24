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
    raise InviteRequired.new('Регистрация только по приглашениям') if session[:invite].nil?
    slim :'operator/register'
  end

  post '/operator/register' do
    raise InviteRequired.new('Регистрация только по приглашениям') if session[:invite].nil?
    invite = Invite.first(:code => session[:invite])
    raise InviteRequired.new('Приглашение уже было использовано ранее') unless invite.invitee.nil?

    identity = Identity.create email: params[:auth_key], password: params[:password], :role => 'operator', :name => params[:name]

    invite.update(invitee: identity)
    session[:invite] = nil

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/operator'
  end

  get '/operator' do
    authorize! :list, :calls
    companies = Target.all(status: nil).company
    slim :'operator/index', locals: {companies: companies}
  end

  get '/operator/call/who' do
    authorize! :make, :calls
    target_contact = TargetContact.get session['target_contact_id']
    json title: (target_contact.name || ''), name: target_contact.target.name
  end

  get '/operator/call/:company' do
    authorize! :make, :calls
    company = Company.get params[:company]

    session[:calling_to_company_id] = company.id

    slim :'operator/call', locals: {company: company}
  end
end
