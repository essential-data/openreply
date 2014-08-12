$('#flash').show()
$('#flash').html(<%= raw (render "shared/messages").to_json %>)
$('.alert-box').fadeOut(3000)

