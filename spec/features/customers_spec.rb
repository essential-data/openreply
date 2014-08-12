# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

feature "Customers statistics", :vcr do
  include FeatureMacros
  #include DbMacros

  before :each do
    db_init
    visit root_path
    sign_in @admin
  end

  scenario "displays list of customers", js: true do
    click_link "Customers"

    expect(find(".title h1")).to have_content "Customers"
    expect(page).to have_selector ".row table"

    expect(page).to have_content "Mikuláš"
    expect(page).to have_content "Starec"
    expect(page).to have_content "Ignac"
  end

  scenario "click customer to show details", js: true do
    click_link "Customers"
    click_link "Starec"
    expect(find(".wall-heading")).to have_content /Statistics.+Starec/
  end

  scenario "sort table", js: true do
    click_link "Customers"
    expect {first("#customers_table th").click()}.to change {first("#customers_table td").text()}
  end

end

