
require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:venue_type) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end

  describe 'factory' do
    it 'is valid' do
      venue = build(:venue)
      expect(venue).to be_valid
    end
  end
end
