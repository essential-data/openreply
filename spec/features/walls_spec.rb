# encoding: utf-8

require 'spec_helper'
require 'vcr_setup'

feature "Wall statistics", :vcr do
  include FeatureMacros

  before :each do
    db_init
    visit root_path
    sign_in @admin
    wait_for_ajax

  end

  scenario "displays options", js: true do
    # Checks default all
    expect(page).to have_content /Employee +All/
    expect(page).to have_content /Customer +All/
    expect(page).to have_content /Period/

  end

  scenario "displays charts", js: true do
    # Checks charts
    expect(page).to have_selector "#rating-histogram-chart svg"
    expect(page).to have_selector "#rating-timeline-chart svg"
    expect(page).to have_selector "#rating-bar-chart svg" if Otrs.using_otrs?
    expect(page).to have_selector ".circle"

  end


  scenario "usage stats are shown", js: true, skip: !Otrs.using_otrs? do
    expect(page).to have_content /Detailed statistics/
    expect(page).to have_content /Rated/
    expect(page).to have_content /Not rated/
  end

  scenario "filters by customer changes usage bar chart", js: true, skip: !Otrs.using_otrs? do
    sleep 1
    expect { select "Ignac", :from => "rating_customer"; wait_for_ajax }.to change {
      res=[]
      all("#rating-bar-chart .highcharts-tracker rect").each { |e| res << e[:y] }
      res
    }
  end


  scenario "filters by customer, changes statistics of usage bar chart", js: true do
    expect { select "Ignac", :from => "rating_customer"; wait_for_ajax }.to change {
      find(".wall-heading").text
    }
  end

  scenario "filter histogram by time period", js: true do
    expect { find("a[data-interval=week]").click; wait_for_ajax }.to change {
      res=[]
      all("#rating-histogram-chart .highcharts-tracker rect").each { |e| res << e[:y] }
      res
    }
  end


  scenario "filters usage bar chart by time", js: true, skip: !Otrs.using_otrs? do
    expect { find('a[data-interval="week"]').click; wait_for_ajax }.to change {
      res=[]
      all("#rating-bar-chart .highcharts-tracker rect").each { |e| res << e[:y] }
      res
    }
  end

  scenario "filters histogram for customer", js: true do
# It changes column chart
    expect { select "Ignac", :from => "rating_customer"; wait_for_ajax }.to change {
      res=[]
      all("#rating-histogram-chart .highcharts-tracker rect").each { |e| res << e[:y] }
      res
    }
# It returns back to all
  end

  scenario "filters timeline for customer", js: true do
    # It changes column chart
    expect { select "Ignac", :from => "rating_customer"; wait_for_ajax }.to change {
      res=[]
      all("#rating-timeline-chart .highcharts-tracker path").each { |e| res << e[:d] }
      res
    }
  end

  scenario "filtered detailed statistics", js: true do
    # It changes column chart
    select "Janko Hraško", :from => "rating_customer"
    find("a[data-interval=week]").click
    wait_for_ajax
    expect { find("a[type=all]").click; wait_for_ajax}.to change {
      res=[]
      all(".circle.outer.gray .white", visible: true).each { |e| res << e.text() }
      res
    }
  end

  scenario "displays table of rating details periods", js: true do
    # Checks list/table of ratings
    expect(page).to have_selector "#ratings-list tr:nth-child(5)"
    expect(page).to have_content "Mikuláš"
    expect(page).to have_content "Nic moc"
  end

  scenario "displays next for rating details", js: true do
    # Checks pagination


    expect(page).to have_content 'Nic moc'
    click_link "Next ›"
    wait_for_ajax
    expect(page).to_not have_content 'Nic moc'
  end


end