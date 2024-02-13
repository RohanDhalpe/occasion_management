# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.customer?
      can :read, User
      can :create, Booking
      can [:update, :destroy], Booking, user_id: user.id, status: 'booked'
    elsif user.admin?
      can :manage, :all
    end
  end
end
