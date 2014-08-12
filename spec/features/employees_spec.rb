# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

feature "Employee statistics", :vcr do
  include FeatureMacros

  before :each do
    db_init
    visit root_path
    sign_in @admin
    sleep 1
  end

  scenario "click employee to show details", js: true do
    click_link "Employees"
    click_link "Fero K"
    expect(find(".wall-heading")).to have_content /Statistics.+Fero/
  end

  scenario "displays detailed list of employees", js: true do
    click_link "Employees"
    expect(find(".title h1")).to have_content "Employees"
    expect(page).to have_selector ".row table"
    expect(page).to have_selector "table tr:nth-child(5)"

    expect(page).to have_content "Fero"
    expect(page).to have_content "Jano"
    expect(page).to have_content "Jožo"
  end

  scenario "sort table", js: true do
    click_link "Employees"
    expect {first("#employees_table th").click()}.to change {first("#employees_table td").text()}
  end


end