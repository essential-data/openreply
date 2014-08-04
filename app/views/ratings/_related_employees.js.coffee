$("#rating_employee").html(<%= raw (render partial: 'related_employees.html.haml', locals: {filter:  @filter}).to_json %>)


