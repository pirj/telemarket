class Ability
  include CanCan::Ability

  def initialize identity
    can :index, :home

    unless identity.nil? or identity.employee.nil?
      unless identity.employee.company.nil?
        can :manage, Company
        can :manage, Plan
        can :manage, TargetGroup
      end
    end

  rescue
  end
end
