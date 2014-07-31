# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :admin, :class => "User" do
		email "admin@example.com"
		password "admin123"	
  end

  factory :admin2, :class => "User" do
    email "admin2@example.com"
    password "admin123"
  end


end
