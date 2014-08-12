require 'rails_helper'
require 'vcr_setup'

describe GraphsController, :vcr, :type => :controller do
  login_admin

  describe '#bar' do
    it 'should complete request', skip: !Otrs.using_otrs? do
      xhr :get, :bar, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(response).to be_success
      expect(response).to render_template 'dashboard/charts/_bar'
    end
    it 'should assign bar' do
      xhr :get, :bar, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(assigns(:bar)).to be_an_instance_of Statistics::Bar
    end
  end

  describe '#histogram' do
    it 'should complete request', skip: !Otrs.using_otrs? do
      xhr :get, :histogram, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(response).to be_success
      expect(response).to render_template 'dashboard/charts/_histogram'
    end
    it 'should assign histogram' do
      xhr :get, :histogram, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(assigns(:histogram)).to be_an_instance_of Statistics::Histogram
    end
  end

  describe '#time_line' do
    it 'should complete request', skip: !Otrs.using_otrs? do
      xhr :get, :time_line, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(response).to be_success
      expect(response).to render_template 'dashboard/charts/_time_line'
    end
    it 'should assign time_interval' do
      xhr :get, :time_line, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(assigns(:time_line)).to be_an_instance_of Statistics::Timeline
    end
  end

  describe '#detailed_statistics' do
    it 'should complete request', skip: !Otrs.using_otrs? do
      xhr :get, :detailed_statistics, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(response).to be_success
      expect(response).to render_template 'dashboard/charts/_statistics'
    end

    it 'should assign detailed statistics' do
      xhr :get, :detailed_statistics, time_interval: "all", employee: "Francis Bosco", _: 1404219728226, format: "js"
      expect(assigns(:detailed_statistics)).to be_an_instance_of Statistics::PersonStatistics
    end
  end



end
