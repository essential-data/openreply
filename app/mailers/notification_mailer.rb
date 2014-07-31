class NotificationMailer < ActionMailer::Base


  default from: "no_reply"

  def new_rating(rating)
    @rating =rating
    mail(to: ENV["SMTP_NEW_NOTIFICATION_ADRESS_LIST"], subject: 'New rating created')
  end

end
