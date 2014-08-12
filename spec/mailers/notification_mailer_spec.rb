require "rails_helper"

RSpec.describe NotificationMailer, :type => :mailer do
  describe '#new_rating' do
    let(:rating) {create :rated}
    let(:mail) {NotificationMailer.new_rating(rating)}

    it 'should render proper info in mail' do
      expect(mail.body.encoded).to have_content rating.int_value
      expect(mail.body.encoded).to have_content rating.text_value
      expect(mail.body.encoded).to have_content rating.employee_name
      expect(mail.body.encoded).to have_content rating.customer_name
      expect(mail.body.encoded).to have_content rating.created_at.strftime("%_H:%m %d.%h.%Y")

    end

  end


end
