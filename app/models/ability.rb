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
      can :read, User do |target_user|
        user.relations.include?(target_user)
      end
      # can [:read], User, :id => relations.last.id

      # can :read, User, if relations_array.include?(user.id)

      
      # User if relations.each do |relation|
      #   relation.user_id == user.id
      # end

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
