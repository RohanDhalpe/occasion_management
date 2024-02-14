FactoryBot.define do
  factory :role do
    name { 'ADMIN' }
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    role { FactoryBot.create(:role) }

    trait :admin do
      role { FactoryBot.create(:role, name: 'ADMIN') }
    end

    trait :customer do
      role { FactoryBot.create(:role, name: 'CUSTOMER') }
    end
  end
end
