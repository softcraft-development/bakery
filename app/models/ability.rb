class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      if user.roles.include? :admin
        can :manage, :all
      end
      
      can :manage, Recipe, :user_id => user.id
      can :create, Recipe
    end
  end
end
