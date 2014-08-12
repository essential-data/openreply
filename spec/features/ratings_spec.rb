require 'rails_helper'
require 'vcr_setup'

feature "Rating form", :vcr do
  include FeatureMacros

  scenario "adds a new rating for correct new link", js: true do
    old_count = Rating.count

    url = root_path+"ratings/new/44312/b87a6e4a8f7ea94e32ef03313e29e8c9"
    uri = URI.parse(URI.encode(url))
    visit uri
    if Otrs.using_otrs?

      expect(page).not_to have_content "Error occured while processing your rating, try again later."
      expect(page).not_to have_content "Internal Server Error"

      expect(page).to have_content "#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}"
      expect(page).to have_selector "textarea#rating_text_value"

      find("img[alt='4']").click
      fill_in "rating_text_value", with: "Super, paráda, luxus"
      click_button "Save rating"
      expect(page).to have_content 'Thanks'

      expect(Rating.count - old_count).to be 1
      expect(Rating.last.int_value).to be 4
      expect(Rating.last.employee_name).to eq "#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}"
      expect(Rating.last.text_value).to eq 'Super, paráda, luxus'
    else
      expect(page).not_to have_content "Error occured while processing your rating, try again later."
      expect(page).not_to have_content "Evaluate agent"
      expect(page).to have_content "404"
      # expect(page.status_code).to eq 500
    end
  end


  scenario "adds a new rating for correct old link", js: true do
    old_count = Rating.count

    url = root_path+"ratings/new?firstname=#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']}&lastname=#{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}&ticketID=44426&customer=essential-data"
    uri = URI.parse(URI.encode(url))
    visit uri

    expect(page).not_to have_content "Error occured while processing your rating, try again later."
    expect(page).not_to have_content "Internal Server Error"

    expect(page).to have_content "#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}"
    expect(page).to have_selector "textarea#rating_text_value"

    find("img[alt='3']").click
    fill_in "rating_text_value", with: "Super, paráda, luxus"
    click_button "Save rating"
    expect(page).to have_content 'Thanks'

    expect(Rating.count - old_count).to be 1
    expect(Rating.last.int_value).to be 3
    expect(Rating.last.employee_name).to eq "#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}"
    expect(Rating.last.text_value).to eq 'Super, paráda, luxus'
  end

  scenario "displays error for incorrect link", js: true do
    allow(Otrs::Client).to receive(:call).and_raise(Otrs::ServiceError)

    url = root_path+"ratings/new/44312/b87a6e4a8f7ea94e32ef03313e29e8c9"
    uri = URI.parse(URI.encode(url))
    visit uri

    expect(page).not_to have_content "Error occured while processing your rating, try again later."
    expect(page).not_to have_content "Evaluate agent"
    if Otrs.using_otrs?
      expect(page).to have_content "We're sorry, but something went wrong."
    else
      expect(page).to have_content "404"
    end
  end

  scenario "language change", js: true do

    url = root_path+"ratings/new?firstname=#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']}&lastname=#{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}&ticketID=44426&customer=essential-data&lang=en"
    uri = URI.parse(URI.encode(url))
    visit uri
    expect(page).not_to have_content "Error occured while processing your rating, try again later."

    expect(page).to have_content "Evaluate employee"
    expect(page).to have_button "Save rating"

    click_link 'SK'
    expect(page).to have_content "Hodnotenie pre"
    expect(page).to have_button "Odošli hodnotenie"

    find("img[alt='4']").click
    fill_in "rating_text_value", with: "Super, paráda, luxus"
    click_button "Odošli hodnotenie"

    expect(page).to have_content "Ďakujeme"
    find('#rated_thanks').native.send_keys(:escape)

    click_link 'EN'
    expect(page).to have_content "Evaluate employee"
    expect(page).to have_button "Save rating"
  end

  scenario "cannot rate twice", js: true do
    old_count = Rating.count

    url = root_path+"ratings/new?firstname=#{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']}&lastname=#{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']}&ticketID=44426&customer=essential-data"
    uri = URI.parse(URI.encode(url))
    visit uri

    find("img[alt='4']").click
    click_button "Save rating"
    expect(page).to have_content I18n.t("thanks")
    expect(Rating.count - old_count).to be 1

    find('#rated_thanks').native.send_keys(:escape)
    click_button "Save rating"
    expect(page).to have_content I18n.t("rating.rated")
    expect(Rating.count - old_count).to be 1
  end
end
