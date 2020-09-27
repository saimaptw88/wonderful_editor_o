FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, max_length: 20, mix_case: true) }
  end
end
