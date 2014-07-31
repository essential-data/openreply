if ('#detailed-statistics').length
  $(".data-filtered .circle.outer").removeClass "gray pink green yellow"


  $(".data-filtered .count .circle.white").html "<%= @detailed_statistics.count[:value] %>"
  $(".data-filtered .count.circle.outer").addClass "<%= @detailed_statistics.count[:color] %>"

  $(".data-filtered .average .circle.white").html "<%= @detailed_statistics.average[:value] %>"
  $(".data-filtered .average.circle.outer").addClass "<%= @detailed_statistics.average[:color] %>"

  $(".data-filtered .median .circle.white").html "<%= @detailed_statistics.median[:value] %>"
  $(".data-filtered .median.circle.outer").addClass "<%= @detailed_statistics.median[:color] %>"

  $(".data-filtered .change .circle.white").html "<%= @detailed_statistics.change[:value] %>"
  $(".data-filtered .change.circle.outer").addClass "<%= @detailed_statistics.change[:color] %>"

  # switch filter button
  if <%= @should_switch %>
    $('.time-switcher a.button').removeClass('success')
    $('.time-switcher a.button[type=filtered]').addClass('success')
    $(".statistics .data").hide()
    $(".statistics .data-filtered").show()
