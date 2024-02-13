# FactoryBot.define do
#   factory :booking do
#     association :user
#     association :venue
#     booking_date { Faker::Date.forward(days: 10) }
#     start_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1, format: :default) }
#     end_time { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 2, format: :default) }
#     status { ['pending', 'confirmed', 'cancelled'].sample }
#   end
# end

FactoryBot.define do
  factory :booking do
    association :user, factory: :user
    association :venue, factory: :venue
    booking_date { Faker::Date.forward(days: 10) }
    start_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1, format: :default) }
    end_time { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 2, format: :default) }
    status { ['pending', 'confirmed', 'cancelled'].sample }
  end
end
