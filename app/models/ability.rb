class Ability
  include CanCan::Ability

  # TODO: Finish assignment of user roles
  def initialize(user)
    user ||= User.new
    if user.role? :parent
      can :manage, User, :id => user.id
      can :manage, Event
      can :manage, Comment
      can [:read, :update, :destroy], Relationship    
    end
    if user.role? :student
      can :manage, User, :id => user.id
      can :manage, Event
      can :manage, Comment
      can [:read, :update, :destroy], Relationship
    end
    if user.role? :tutor
      can :manage, User, :id => user.id
      can :manage, Event
      can :manage, Comment
      can :manage, Relationship
    end
    if user.role? :admin
      can :manage, :all
    end
  else
    can :create, User
  end
end
