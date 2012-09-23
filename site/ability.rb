class Ability
  include CanCan::Ability

  def initialize identity
    can :index, :home

    unless identity.nil? or identity.company.nil?
      can :manage, Company
      can :manage, Target
    end

  rescue
  end
end
