class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      if user.roles.include? :admin
        can :manage, :all
      end
    end
  end
end
