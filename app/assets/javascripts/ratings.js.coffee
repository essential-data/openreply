$(document).ready ->
  rating_sending_bind()

rating_sending_bind = ->
  $('#submit-button').bind('click',( ->
    if $('#rating_value').val() == '0'
      $('#no_star_selected').foundation('reveal', 'open');
      false
  ))

