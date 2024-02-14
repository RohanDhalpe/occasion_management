
require 'rails_helper'

RSpec.describe Booking, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:venue_id) }
    it { should validate_presence_of(:booking_date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:venue) }
  end

  describe 'factory' do
    it 'is valid' do
      # Arrange
      role = create(:role)
      user = create(:user, role: role)
      venue = create(:venue)

      booking = Booking.new(
        user: user,
        venue: venue,
        booking_date: '2024-02-20',
        start_time: '2024-02-13 20:23:30',
        end_time: '2024-02-14 17:42:20',
        status: 'cancelled'
      )

      expect(booking).to be_valid
    end
  end
end
