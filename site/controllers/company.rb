# coding: utf-8
require 'csv'

class Site < Sinatra::Base
  get '/company/register' do
    slim :'company/register'
  end

  post '/company/register' do
    identity = Identity.create email: params[:auth_key], password: params[:password], password_confirmation: params[:password], :role => 'customer', :name => params[:name]
    puts identity.errors.inspect
    puts identity
    company = Company.create name: params[:company], :identity => identity
    puts company.errors.inspect
    puts company

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!  + #{Time.now}"
    redirect '/company'
  end

  get '/company' do
    authorize! :view, Company
    company = current_user.company
    slim :'company/index', locals: {company: company}
  end

  get '/company/instructions' do
    authorize! :view, Company
    company = current_user.company
    slim :'company/instructions', locals: {company: company}
  end

  post '/company/instructions' do
    authorize! :edit, Company
    company = current_user.company
    company.instructions = params[:text]
    company.save

    redirect '/company'
  end

  get '/company/targets' do
    authorize! :index, Target
    company = current_user.company
    slim :'company/targets', locals: {company: company}
  end

  post '/company/target/create' do
    authorize! :create, Target
    company = current_user.company

    Target.create name: params[:name], phone: params[:phone], company: company
    redirect '/company/targets'
  end

  post '/company/target/upload' do
    authorize! :create, Target
    company = current_user.company

    puts params.inspect
    file = File.new params[:file]

    CSV.parse(file.read) do |row|
      target = Target.create name: row[0], phone: row[1], company: company
    end

    redirect '/company/targets'
  end
end
