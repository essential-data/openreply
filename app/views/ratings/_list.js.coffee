if $("#ratings-list").length
  $("#ratings-list").html(<%= raw (render "index.html.haml").to_json %>)
  $('#ignored a').each ->
    $(this).bind("ajax:success", ->
      update_chart("/ratings")
    )

