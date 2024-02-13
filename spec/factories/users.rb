FactoryBot.define do
  factory :role do
    name { 'ADMIN' } # Adjust as necessary for your role names
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    role { FactoryBot.create(:role) } # Create a valid role association

    trait :admin do
      role { FactoryBot.create(:role, name: 'ADMIN') } # Assuming 'ADMIN' is the role name for admins
    end

    trait :customer do
      role { FactoryBot.create(:role, name: 'CUSTOMER') } # Assuming 'CUSTOMER' is the role name for customers
    end
  end
end
