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
    authorize! :view, Company
    company = current_user.employee.company
    slim :'company/index', locals: {company: company}
  end

  get '/company/plans' do
    authorize! :index, Plan
    company = current_user.employee.company
    slim :'company/plans', locals: {company: company}
  end

  post '/company/add-plan' do
    authorize! :add, Plan
    company = current_user.employee.company
    plan = Plan.create company: company, name: params[:name], description: params[:description]
    params[:group].keys.each do |group_id|
      plan.target_groups << TargetGroup.first(company: company, id: group_id)
    end
    plan.save
    redirect "/company/plans"
  end

  get '/company/target-groups' do
    authorize! :index, TargetGroup
    company = current_user.employee.company
    slim :'company/target-groups', locals: {company: company}
  end

  post '/company/add-group' do
    authorize! :add, TargetGroup
    company = current_user.employee.company
    TargetGroup.create company: company, name: params[:name]
    redirect '/company/target-groups'
  end

  get '/company/target-group/:id' do
    authorize! :view, TargetGroup
    company = current_user.employee.company
    group = TargetGroup.first(company: current_user.employee.company, id: params[:id])
    slim :'company/target-group', locals: {company: company, group: group}
  end

  post '/company/add-target/:id' do
    authorize! :add, Target
    group = TargetGroup.first(company: current_user.employee.company, id: params[:id])
    target = Target.create target_group: group, name: params[:name]
    Contact.create target: target, name: params[:name], phone: params[:phone]
    redirect "/company/target-group/#{params[:id]}"
  end
end
