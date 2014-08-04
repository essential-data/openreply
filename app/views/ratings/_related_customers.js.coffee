$("#rating_customer").html(<%= raw (render partial: "related_customers.html.haml", locals: {filter:  @filter}).to_json %>)

