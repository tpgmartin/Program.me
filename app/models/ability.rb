class Ability
  include CanCan::Ability

  # TODO: Finish assignment of user roles
  def initialize(user)
    user ||= User.new

    if user.role? :parent
      can :manage, User, :id => user.id

      can :create, Event       
      can [:read, :update, :destroy], Event do |target_event|
        user.events.include?(target_event)
      end
      
      can :read, Comment
      can :manage, Comment, :user_id => user.id

      # can :manage, Comment do |target_comment|
      #   user.comments.include?(target_comment)
      # end
      can [:read, :update, :destroy], Relationship    
    end
    if user.role? :student
      can :manage, User, :id => user.id

      can :create, Event       
      can [:read, :update, :destroy], Event do |target_event|
        user.events.include?(target_event)
      end

      can :create, Comment
      can :manage, Comment, :user_id => user.id

      # can :manage, Comment do |target_comment|
      #   user.comments.include?(target_comment)
      # end
      can [:read, :update, :destroy], Relationship
    end

    if user.role? :tutor
      can :manage, User, :id => user.id
      can :read, User 
      # can [:read], User, :id => relations.last.id

      # can :read, User, if relations_array.include?(user.id)

      
      # User if relations.each do |relation|
      #   relation.user_id == user.id
      # end

      can :create, Event       
      can [:read, :update, :destroy], Event do |target_event|
        user.events.include?(target_event)
      end

      can [:create, :read], Comment
      can :manage, Comment, :user_id => user.id

      can :manage, Relationship
    end
    if user.role? :admin
      can :manage, :all
    end
  else
    can :create, User
  end

end
