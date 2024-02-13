# spec/factories/roles.rb
FactoryBot.define do
  factory :custom_role, class: Role do
    name { 'ADMIN' } # Adjust as necessary for your role names
  end
end
