module Otrs
  module TicketValidator

    # Return true when the hash for the ticket id is valid, false otherwise
    #
    # @param [String] hash
    # @param [Fixnum | String] ticket_id
    # @return [TrueClass | FalseClass]
    def self.valid_hash?(hash, ticket_id)
      control_hash = Digest::MD5.hexdigest(ticket_id.to_s + ENV['OPENREPLY_OTRS_SHARED_SECRET'])

      Rails.logger.info "Validating ticket with secret, sent hash is \"" + hash + "\""
      Rails.logger.info "Validating ticket with secret, correct hash should be \"" + control_hash + "\""

      hash == control_hash
    end
  end
end
