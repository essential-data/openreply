# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe Otrs::Client, :vcr do

  describe "::call" do
    let(:url) { "#{Settings.otrs_api.url}/api/ticket/" }
    let(:id) { 45420 }

    it "returns a valid response", skip: !Otrs.using_otrs? do
      result = Otrs::Client.call(url, { id: id })

      expect(result).to be_a Hash
      expect(result).to have_key "objects"
    end

    context "RestClient::InternalServerError" do
      it "raises Otrs::ServiceError" do
        allow(RestClient).to receive(:get).and_raise RestClient::InternalServerError

        expect do
          Otrs::Client.call(url, { id: id })
        end.to raise_error(Otrs::ServiceError).with_message("Internal server error")
      end
    end

    context "SocketError" do
      it "raises Otrs::ServiceError" do
        allow(RestClient).to receive(:get).and_raise SocketError

        expect do
          Otrs::Client.call(url, { id: id })
        end.to raise_error(Otrs::ServiceError).with_message("Can not connect to OTRS, server is unavailable")
      end
    end

    context "Errno::ENETUNREACH" do
      it "raises Otrs::ServiceError" do
        allow(RestClient).to receive(:get).and_raise Errno::ENETUNREACH

        expect do
          Otrs::Client.call(url, { id: id })
        end.to raise_error(Otrs::ServiceError).with_message("Can not connect to OTRS, server is unavailable")
      end
    end
  end

end
