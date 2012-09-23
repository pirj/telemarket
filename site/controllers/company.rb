# coding: utf-8
class Site < Sinatra::Base
  get '/company/register' do
    slim :'company/register'
  end

  post '/company/register' do
    company = Company.new name: params[:company]
    identity = Identity.create email: params[:auth_key], password: params[:password], password_confirmation: params[:password], :role => 'customer'

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/company'
  end

  get '/company' do
    authorize! :view, Company
    company = current_user.employee.company
    slim :'company/index', locals: {company: company}
  end

  get '/company/targets' do
    authorize! :index, Target
    company = current_user.company
    slim :'company/targets', locals: {company: company}
  end

  post '/company/target/create' do
    authorize! :create, Target
    target = Target.create name: params[:name], phone: params[:phone]
  end
end
