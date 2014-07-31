# encoding: utf-8

module Otrs

  # OTRS API simple REST client
  # It's used in resources like Otrs::Ticket, Otrs::Article etc.
  module Client

    # Call the API and return the response, also handle possible Errors
    #
    # @param [String] url - Example: https://username:password@otrs.domain.com:5443/api/ticket/
    # @param [Hash] params - parameters needed for that call - Example: { ticket_id: 123 }
    # @return [RestClient::Response]
    def self.call(url, params)
      begin
        response = RestClient.get url, { accept: :json, params: params }
        raise Otrs::ServiceError.new, "OTRS web service error" if response.code != 200

        response_hash = JSON.parse(response)
        raise Otrs::IDNotFoundError.new, "Object not found" if response_hash["objects"].empty?

        return response_hash
      rescue RestClient::InternalServerError => ise
        raise Otrs::ServiceError.new, "Internal server error"
      rescue SocketError, Errno::ENETUNREACH => e
        raise Otrs::ServiceError.new, "Can not connect to OTRS, server is unavailable"
      end
    end
  end
end
