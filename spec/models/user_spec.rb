require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest).on(:create) }
  end

  describe 'associations ww' do
    subject { FactoryBot.build(:user) }
    it { should validate_uniqueness_of(:email).case_insensitive}
  end

  describe 'associations' do
    it { should belong_to(:role) }
    it { should have_many(:bookings) }
  end


  describe 'methods' do
    it 'should return true for admin?' do
      user = FactoryBot.create(:user, role: Role.find_or_create_by(name: 'ADMIN'))
      expect(user.admin?).to eq(true)
    end

    it 'should return true for customer?' do
      user = FactoryBot.create(:user, role: Role.find_or_create_by(name: 'CUSTOMER'))
      expect(user.customer?).to eq(true)
    end
  end

  describe 'validations' do
    subject { FactoryBot.build(:user) } # Use build to create a new record without saving it

    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
