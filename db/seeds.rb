# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts '======================================================================='
puts '*** Creating admin user... ***'
begin
  admin = User.create!(:email => ENV['OPENREPLY_ADMIN_USER'], :password => ENV['OPENREPLY_ADMIN_PASSWORD'])
  puts 'User was successfully created:'
  puts "email: #{admin.email}"
  puts "password: #{admin.password}"
rescue Exception => e
  puts "Error during creation admin user!"
  puts e
end
puts '======================================================================='

puts '======================================================================='
puts '*** Creating random ratings... ***'
begin
  50.times do
    Rating.create! do |r|
      r.int_value = (0..5).to_a.sample

      res = ""
      10.times { res+=["lorem ", "ipsum "].sample }
      r.text_value = res

      res = ""
      10.times { res+=(0..9).to_a.sample.to_s }
      r.ticket_id = res

      r.employee = Employee.find_or_create_by_first_name_and_last_name(["Fero", "Jano", "Kubo", "Peter"].sample, ["R", "M", "S", "E"].sample)
      r.customer = Customer.find_or_create_by_name(["FrantišekC", "JánC", "JakubC", "KvetoslavC"].sample)

      res = ""+(0..255).to_a.sample.to_s
      3.times { res+="."+(0..255).to_a.sample.to_s }
      r.client_ip = res
      r.created_at = Time.now - 50.day + rand * 50.day
    end
  end
rescue Exception => e
  puts "Error during creation of ratings!"
  puts e
end
puts '======================================================================='
