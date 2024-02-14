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

  describe '#as_json' do
    let(:user) { FactoryBot.create(:user) }
    let(:json) { user.as_json }

    it 'returns a hash without created_at, updated_at, and password_digest' do
      expect(json.keys).to match_array(['id', 'name', 'email', 'role_id'])
      expect(json.keys).not_to include('created_at', 'updated_at', 'password_digest')
    end

    it 'includes other attributes' do
      expect(json['id']).to eq(user.id)
      expect(json['name']).to eq(user.name)
      expect(json['email']).to eq(user.email)
      expect(json['role_id']).to eq(user.role_id)
    end

    it 'accepts options' do
      json_with_options = user.as_json(only: [:name, :email])
      expect(json_with_options.keys).to match_array(['name', 'email'])
      expect(json_with_options.keys).not_to include('id', 'role_id', 'created_at', 'updated_at', 'password_digest')
    end
  end
end
