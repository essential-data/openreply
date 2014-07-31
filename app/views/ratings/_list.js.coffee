if $("#ratings-list").length
  $("#ratings-list").html(<%= raw (render "index.html.haml").to_json %>)
