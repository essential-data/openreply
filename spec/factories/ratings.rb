# Read about factories at https://github.com/thoughtbot/factory_girl
require "faker"

FactoryGirl.define do
  factory :rating do
    ticket_id { Faker::Number.number 5 }
    ticket_number { Faker::Number.number 8 }
    employee { create :employee }
    customer { create :customer }

    factory :rated do
      text_value { Faker::Lorem.paragraph }
      int_value { (0..Settings.max_int_rating).to_a.sample }
      client_ip { Faker::Internet.ip_v4_address }
      created_at { @t = Time.now  - 1.days }
      updated_at { @t }


      factory :older do
        created_at { @t = Time.now - 10.days }
        updated_at { @t }
      end

      factory :oldest do
        created_at { @t = Time.now - 50.days }
        updated_at { @t }
      end

      factory :newer do
        created_at { @t = Time.now - 3.days }
        updated_at { @t }
      end

      factory :newest do
        created_at { @t = Time.now }
        updated_at { @t }
      end
    end

  end
end