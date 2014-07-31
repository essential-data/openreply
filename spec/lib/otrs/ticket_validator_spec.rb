require 'spec_helper'

describe Otrs::TicketValidator do

  describe "::valid_hash?" do
    it "returns true for valid hash" do
      hash = "1c6103e7996e6d6129ce0f11e0237d1b"
      valid_ticket_id = 45420

      expect(Otrs::TicketValidator.valid_hash?(hash, valid_ticket_id)).to be true
    end

    it "returns false for invalid hash" do
      hash = "__INVALID__"
      invalid_ticket_id = 11111

      expect(Otrs::TicketValidator.valid_hash?(hash, invalid_ticket_id)).to be false
    end
  end

end
