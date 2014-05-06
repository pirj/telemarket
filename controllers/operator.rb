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

    email = params[:auth_key]
    identity = Identity.create email: email, password: params[:password], :role => 'operator', :name => params[:name]

    if identity.errors.empty?
      Mail.new do
        from     'info@gotelemarket.com'
        to       email
        subject  'Телемаркет'
   
        html_part do
          content_type 'text/html; charset=UTF-8'
          body     "Добро пожаловать!"
        end
      end.deliver

      invite.invitee = identity
      invite.save
      session[:invite] = nil

      session[:user_id] = identity.id
      flash[:info] = "Добро пожаловать!"

      redirect '/operator'
    else
      flash['error'] = identity.errors.values.join('. ')
      redirect '/'
    end
  end

  get '/operator' do
    authorize! :list, :calls
    companies = Target.all(status: :in_progress).company
    slim :'operator/index', locals: {companies: companies}
  end

  get '/operator/call/who' do
    authorize! :make, :calls
    target_contact = TargetContact.get session['target_contact_id']
    json title: target_contact.target.name, name: (target_contact.name || '')
  end

  post '/operator/call/transfer' do
    authorize! :make, :calls
    redis = EM::Hiredis.connect
    session_id = env['rack.session.options'][:id]
    redis.publish "transfer.#{session_id}", "dummy"

    target_contact = TargetContact.get session['target_contact_id']
    target_contact.status = :transferred
    target_contact.result = params[:result]
    target_contact.save
    target = target_contact.target
    target.status = :success
    target.save
  end

  post '/operator/call/success' do
    authorize! :make, :calls

    target_contact = TargetContact.get session['target_contact_id']
    target_contact.status = :success
    target_contact.result = params[:result]
    target_contact.save
    target = target_contact.target
    target.status = :success
    target.save
  end

  post '/operator/call/not_interested' do
    authorize! :make, :calls

    target_contact = TargetContact.get session['target_contact_id']
    target_contact.status = :not_interested
    target_contact.result = params[:result]
    target_contact.save
    target = target_contact.target
    target.status = :not_interested
    target.save
  end

  post '/operator/call/wrongnumber' do
    authorize! :make, :calls
    target_contact = TargetContact.get session['target_contact_id']

    target_contact = TargetContact.get session['target_contact_id']
    target_contact.status = :wrongnumber
    target_contact.result = params[:result]
    target_contact.save
    target = target_contact.target
    if target.target_contact(status: :not_called).empty?
      target.status = :no_numbers
      target.save
    end
  end

  post '/operator/call/disconnected' do
    authorize! :make, :calls
    # do nothing for now
  end

  post '/operator/call/newcontact' do
    authorize! :make, :calls
    target_contact = TargetContact.get session['target_contact_id']
    target = target_contact.target
    # TODO: normalize phone number
    # TODO: add email
    # TODO: ceo checkbox
    TargetContact.create({target: target, name: params[:name], phone: params[:phone]})
  end

  get '/operator/call/:company' do
    authorize! :make, :calls
    company = Company.get params[:company]

    session[:calling_to_company_id] = company.id

    slim :'operator/call', locals: {company: company}
  end
end
