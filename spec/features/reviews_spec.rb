require 'rails_helper'

feature "Review form" do
  include FeatureMacros

  before :each, :js do
    db_init
    visit root_path
    sign_in @admin
    wait_for_ajax
  end


  scenario "has all elements", :js do
    employee = first("#table-data td a").text
    feedback = first("#rating_text span").text.strip
    score = first("#ratings-list .circle .white").text.strip

    first("#reviewed a").click
    wait_for_ajax
    fill_in('review_text', :with => 'Abakuka')
    expect(first(".review-rating").text).to have_content(I18n.t("rating.review.feedback"))
    expect(first(".review-rating").text).to have_content(I18n.t("rating.review.review").upcase)
    expect(first(".review-rating").text).to have_content(I18n.t("cancel"))
    expect(first(".review-rating").text).to have_content(employee)
    expect(first(".review-rating").text).to have_content(feedback[0..9])
    expect(first(".review-rating .circle .white").text.strip).to eq score
    expect(first(".review-rating").text).to have_content(I18n.t("rating.review.ignored"))
    expect(first(".review-rating").text).to have_content(I18n.t("rating.review.reviewed"))
    expect(first(".review-rating")).to have_css(".circle")
    expect(first(".review-rating")).to have_css("#review_text")
    expect(first(".review-rating")).to have_css("#submit-button")
  end


  # scenario "write review and ignore", :js do
  #   first("#reviewed a").click
  #   wait_for_ajax
  #   fill_in('review_text', :with => 'blablabla')
  #   find("#review_ignored_rating").click()
  #   find("#submit-button").click()
  #   wait_for_ajax
  #   expect(find("#reload-graphs")).to be_visible
  #   expect(first("#reviewed .has-tip")["title"]).to eq "blablabla"
  #   expect(first("#ignored a").text).to eq I18n.t("yes")
  #
  #   find("#reload-graphs").click
  #   wait_for_ajax
  #   first("#reviewed a").click
  #   wait_for_ajax
  #   fill_in('review_text', :with => 'Abakuka')
  #   find("#review_ignored_rating").click
  #   find("#submit-button").click
  #   wait_for_ajax
  #   expect(find("#reload-graphs")).to be_visible
  #   expect(first("#reviewed .has-tip")["title"]).to eq "Abakuka"
  #   expect(first("#ignored a").text).to eq I18n.t("no")
  #
  # end
  #
  # scenario "fast ignore", :js do
  #   expect {first("#ignored a").click(); wait_for_ajax}.to change {first("#ignored a").text()}
  # end


end