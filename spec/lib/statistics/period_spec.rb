require 'spec_helper'

describe Statistics::Period do
  before :each do
    allow(Time).to receive(:now).and_return Time.new(2014,7,24)
  end

  describe "::period_to_start_date" do
    it "raises an error for unknown period name" do
      expect do
        Statistics::Period.period_to_start_date(:not_available)
      end.to raise_error(RuntimeError).with_message "Unknown time period"
    end

    it "returns date from 1 week ago for :week" do
      date = Statistics::Period.period_to_start_date(:week)

      expect(date).to eq Time.new(2014, 7, 17).strftime('%Y-%m-%d')
    end

    it "returns date from 31 days ago for :month" do
      date = Statistics::Period.period_to_start_date(:month)

      expect(date).to eq Time.new(2014, 6, 23).strftime('%Y-%m-%d')
    end

    it "returns date from 365 days ago, or the app deploy date for :year" do
      date = Statistics::Period.period_to_start_date(:year)

      expect(date).to eq Settings.dates.app_deploy_date
    end
  end
end