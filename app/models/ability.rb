# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.customer?
      can :read, User

    end

    can :update, User
  end
end
