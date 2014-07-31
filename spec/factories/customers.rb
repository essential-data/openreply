# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do

    name { Faker::Name.first_name + " " + Faker::Name.last_name }

  end


end
