# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :possible_rating do
    date "2014-07-17"
    count 1
    customer nil
    employee nil
  end
end
