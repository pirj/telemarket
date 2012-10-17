# coding: utf-8
require 'csv'

class Site < Sinatra::Base
  get '/company/register' do
    raise InviteRequired.new('Регистрация только по приглашениям') if session[:invite].nil?
    slim :'company/register'
  end

  post '/company/register' do
    raise InviteRequired.new('Регистрация только по приглашениям') if session[:invite].nil?
    invite = Invite.first(:code => session[:invite])
    raise InviteRequired.new('Приглашение уже было использовано ранее') unless invite.invitee.nil?

    identity = Identity.create email: params[:auth_key], password: params[:password], :role => 'customer', :name => params[:name]
    company = Company.create name: params[:company], :identity => identity

    invite.update(invitee: identity)
    session[:invite] = nil

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/company'
  end

  get '/company' do
    authorize! :view, Company
    company = current_identity.company
    slim :'company/index', locals: {company: company}
  end

  get '/company/instructions' do
    authorize! :view, Company
    company = current_identity.company
    slim :'company/instructions', locals: {company: company}
  end

  post '/company/instructions' do
    authorize! :edit, Company
    company = current_identity.company
    company.instructions = params[:text]
    company.save

    redirect '/company'
  end

  get '/company/targets' do
    authorize! :index, Target
    company = current_identity.company
    slim :'company/targets', locals: {company: company}
  end

  def convert_phone phone, prefix
    digits = phone.gsub(/[\s\(\)-]/, '')
    digits = digits[-([digits.length, 10].min)..-1]
    "+#{prefix[0..(10-digits.length)]}#{digits}"[0..11]
  end

  def extract_phones phones, prefix
    return if phones.nil?
    phones.scan(/((\d+[-\(\)]{,1}[\s]{,1})+)/).map(&:first).map do |phone|
      convert_phone phone, prefix
    end
  end

  def parse_file file

  end

  # CSV.parse(File.new(File.join(Dir.pwd, "../misc/eurooffice.csv")).read) do |r|
  #   r.shift # number
  #   company_name = r.shift
  #   public_phones = extract_phones r.shift, "7812"
  #   last_phone = extract_phones r.shift, "7812"

  #   puts "#{public_phones} #{last_phone}"
  # end

  post '/company/target/upload' do
    authorize! :create, Target
    company = current_identity.company

    # file = File.new 
    params[:file]

    STDOUT.puts params #[:file]

    redirect '/company/targets'
  end
end
