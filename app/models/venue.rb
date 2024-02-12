class Venue < ApplicationRecord
  has_many :bookings
  validates :name, presence: true

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at]))
  end
end
