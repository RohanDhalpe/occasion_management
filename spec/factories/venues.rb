# spec/factories/venues.rb
FactoryBot.define do
  factory :venue do
    name { Faker::Company.name }
    venue_type { %w[Conference_Room Auditorium Banquet_Hall].sample }
    start_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default) }
    end_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1, format: :default) }
  end
end
