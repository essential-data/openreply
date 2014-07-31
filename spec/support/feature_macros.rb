module FeatureMacros
  def sign_in user
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "submit-button"
  end

  def db_init
    # puts "before :all"
    @ratings = create_list :rated, 10

    @new_rating = create :newest, customer: (create :customer, name: "Mikuláš"), employee: (create :employee, first_name: "Fero", last_name: "K"), text_value: "Super fantazia, parádička"
    @old_rating = create :oldest, customer: (create :customer, name: "Starec"), employee: (create :employee, first_name: "Jano", last_name: "J"), text_value: "Nic moc"

    @rating_one_user = []
    @values = [2, 2, 3, 4]
    e99 = create :employee, first_name: "Jožo", last_name: "J"
    @values.each { |v| @rating_one_user << (create :rated, int_value: v, employee: e99) }

    @rating_one_customer = []
    @values = [2, 2, 3, 4]

    customer_1 = create :customer, name: 'Ignac'
    customer_all = create :customer, name: ('all')
    @values.each { |v| @rating_one_user << (create :rated, int_value: v, customer: customer_1) }

    c1 = create :customer, name: "Janko Hraško"
    c2 = create :customer, name: "Jurko Hraško"
    c3 = create :customer, name: "Ferko Mrkvička"
    c4 = create :customer, name: "Maros"

    e1 = create :employee, first_name: "Janko", last_name: "Marienka"
    e2 = create :employee, first_name: "Ferko", last_name: "Mrkvička"
    e3 = create :employee, first_name: "Jurko", last_name: "Hraško"

    create(:newer, customer: c1, employee: e1, int_value: 5)
    create(:newer, customer: c1, employee: e1, int_value: 5)
    create(:newer, customer: c1, employee: e2, int_value: 4)
    create(:newest, customer: c2, employee: e3)
    create(:newer, customer: c2, employee: e3)
    create(:older, customer: c1, employee: e3, int_value: 2)
    create(:older, customer: c3, employee: e1)
    create(:older, customer: c3, employee: e1)
    create(:older, customer: c1, employee: e1, int_value: 2)


    @admin = create :admin
  end
end