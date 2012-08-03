# coding: utf-8
class Site < Sinatra::Base
  get '/company/register' do
    slim :'company/register'
  end

  post '/company/register' do
    company = Company.new name: params[:company]
    identity = Identity.create email: params[:auth_key], password: params[:password], password_confirmation: params[:password], :role => 'customer'
    Employee.create name: params[:name], company: company, identity: identity

    session[:user_id] = identity.id
    flash[:info] = "Добро пожаловать!"
    redirect '/company'
  end

  get '/company' do
    @company = current_user.employee.company
    slim :'company/index'
  end

  get '/company/plans' do
    @company = current_user.employee.company
    slim :'company/plans'
  end

  get '/company/target-groups' do
    @company = current_user.employee.company
    slim :'company/target-groups'
  end
end
