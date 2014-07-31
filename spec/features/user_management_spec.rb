# encoding: utf-8

require 'spec_helper'
require 'vcr_setup'

feature 'User', :vcr do
  include FeatureMacros

  before :each do
    db_init
    visit root_path
  end

  def validate_main
    expect(page).not_to have_content /WALL/
    expect(page).not_to have_content /EMPLOYEES/
    expect(page).not_to have_content /CUSTOMERS/

    expect(page).to have_content /username/i
    expect(page).to have_content /Password/i

    expect(page).to have_selector "input#user_email"
    expect(page).to have_selector "input#user_password"


  end

  scenario "no menu without login, basic screen" do
    validate_main
  end

  scenario "has menu after login", js: true do
    sign_in @admin

    expect(page).to have_content /WALL/
    expect(page).to have_content /EMPLOYEES/
    expect(page).to have_content /CUSTOMERS/
  end

  scenario "logout", js: true do
    sign_in @admin

    click_link "Logout"

    validate_main
  end

end