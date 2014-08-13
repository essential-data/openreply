$('.review-rating').remove()
$("body").append("<%=escape_javascript(render partial: 'new') %>");

$(".review-rating").foundation().foundation('reveal', 'open', {"dismissmodalclass": 'close-link'})

