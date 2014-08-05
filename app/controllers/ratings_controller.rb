class RatingsController < ApplicationController
  require "browser"

  # devise method to allow listed actions without user logged in
  skip_before_action :authenticate_user!, only: [:new_from_personal_details, :new_validated_by_hash, :create]

  def index
    customer, employee, interval, from, to = Dashboard::Wall.process_parameters params

    @filtered_ratings = Dashboard::FilteredRatings.new customer, employee, interval, from, to
    @rating_list = Statistics::ListFeedback.new @filtered_ratings.ratings, params["order"], params["page"]

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "list" }
    end

  end

  # new format for url "ratings/new/:ticket_id/:hash/:lang"  ... ratings/44312/b87a6e4a8f7ea94e32ef03313e29e8c9
  def new_validated_by_hash
    # receiving ticket details from otrs
    # validation based on hash and shared secret between otrs and openreply
    ticket = Otrs::Ticket.find_by_id(params['ticket_id']) if Otrs.using_otrs? && Otrs::TicketValidator.valid_hash?(params['hash'], params['ticket_id'])
    if !ticket
      render_404
      return
    end

    @rating = Rating.new_from_customer_and_ticket_and_employee(ticket.customer, params['ticket_id'], ticket.employee_firstname, ticket.employee_lastname)

    if !@rating
      render_404
    elsif browser.modern?
      # decision if layout for old browser (IE 8 < ) should be used or the new zurb foundation (jquery 2.0)
      render :new, layout: 'new_rating'
    else
      render "ratings/ie/new", layout: "ie"
    end
  end

# the old generated url in format ratings/new?firstname=John&lastname=Example&ticketID=12345&customer=company#
  def new_from_personal_details
    if params["firstname"].blank? || params["lastname"].blank? || (Otrs.using_otrs? && params['ticketID'].blank?)
      render_404
      return
    end

    @rating = Rating.new_from_customer_and_ticket_and_employee(params['customer'] || Settings.otrs_api.unknown_customer_name, params['ticketID'], params["firstname"], params["lastname"])

    if !@rating
      render_404
    elsif browser.modern?
      render :new, layout: 'new_rating'
    else
      render "ratings/ie/new", layout: "ie"
    end
  end

  def create
    @rating = Rating.new_from_ticket_and_rated_values_and_ip params['rating'], params['rating']['value'], params['rating']['text_value'], request.remote_ip
    if !@rating # rating contains error text
      render js: "$('#val_error').foundation('reveal', 'open');"
    elsif cookies[@rating.cookie_key] == "rated"
      render js: "$('#rated_error').foundation('reveal', 'open');"
    elsif @rating.save
      NotificationMailer.new_rating(@rating).deliver if Settings.new_rating_notifications_emails
      cookies[@rating.cookie_key] = {value: "rated", expires: 1.hour.from_now}
      if browser.modern?
        render js: "$('#rated_thanks').foundation('reveal', 'open');"
      else
        redirect_to Settings.redirect_to_webpage
      end
    else
      render js: "alert(\"#{t :error, scope: :rating}!\");"
    end
  end

  def related_customers
    customer, employee, interval, from, to = Dashboard::Wall.process_parameters params
    @filter = Dashboard::Filter.new(customer, employee, interval, from, to)

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: 'related_customers' }
    end

  end

  def related_employees
    customer, employee, interval, from, to = Dashboard::Wall.process_parameters params
    @filter = Dashboard::Filter.new(customer, employee, interval, from, to)

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: 'related_employees'}
    end

  end

end
