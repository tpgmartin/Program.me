class Ability
  include CanCan::Ability

  # TODO: Finish assignment of user roles
  def initialize(user)
    user ||= User.new

    if user.role? :parent
      can :manage, User, :id => user.id
      can :manage, Event 
      can [:read, :edit], Event do |target_event|
        user.events.include?(target_event)
      end
      can :manage, Comment do |target_comment|
        user.comments.include?(target_comment)
      end
      can [:read, :update, :destroy], Relationship    
    end
    if user.role? :student
      can :manage, User, :id => user.id
      can :create, Event
      can [:read, :edit], Event do |target_event|
        user.events.include?(target_event)
      end
      can :manage, Comment do |target_comment|
        user.comments.include?(target_comment)
      end
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

      can :create, Event       
      can [:read, :edit], Event do |target_event|
        user.events.include?(target_event)
      end
      can :manage, Comment do |target_comment|
        user.comments.include?(target_comment)
      end
      can :manage, Relationship
    end
    if user.role? :admin
      can :manage, :all
    end
  else
    can :create, User
  end

end
