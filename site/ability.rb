class Ability
  include CanCan::Ability

  def initialize identity
    can :index, :home

    unless identity.nil?
      unless identity.company.nil?
        can :manage, Company
        can :manage, Target
      end
      if identity.role == 'operator'
        can :manage, :calls
      end
    end

  rescue
  end
end
