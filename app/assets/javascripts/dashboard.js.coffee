# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/

$(document).ready ->
  select_init()
  employee_change_update_bind()
  customer_change_update_bind()
  time_interval_change_bind()
  detailed_statistic_switcher()

  update_all_charts()

# bind employees' select list change
employee_change_update_bind = ->
  $('#rating_employee').change ->
    update_all_charts()

# bind customer' select list change
customer_change_update_bind = ->
  $('#rating_customer').change ->
    update_all_charts()

# bind interval [all|week|month|year|custom] change
time_interval_change_bind = ->
  $('a.button.interval').click ->
    $('a.button.interval').removeClass('success')
    $(this).addClass('success')

    if $(this).data('interval') == 'custom'
      date_interval_picker()
    else
      update_all_charts()

# show and handle custom interval date-picker view
date_interval_picker = ->
  $('#datepickerModal').foundation('reveal', 'open')
  $(".reveal-modal").off "close"
  $(".reveal-modal").on "close", ->
    update_all_charts()

# handle [all|filtered] switch of detailed statistics
detailed_statistic_switcher = ->
  $('.time-switcher a.button').click ->
    switch_statistics_button this

# initialize all charts updating
update_all_charts = ->
  filter = filter_setup_variables()
  if $("h1.wall-heading").length
    heading_update()
  if $('#rating-bar-chart').length
    $('#rating-bar-chart').html('')
    $('#rating-bar-chart').addClass('loading')
    update_chart("bar", filter)
  if $('#rating-histogram-chart').length
    $('#rating-histogram-chart').html('')
    $('#rating-histogram-chart').addClass('loading')
    update_chart("histogram", filter)
  if $('#detailed-statistics').length
    switch_statistics_button $('.time-switcher a.button[type=all]')
    update_chart("detailed_statistics", filter)
  if $('#rating-timeline-chart').length
    $('#rating-timeline-chart').html('')
    $('#rating-timeline-chart').addClass('loading')
    update_chart("time_line", filter)
  if $("#ratings-list").length
    $('#table-data').html('')
    $('#table-data').addClass('loading')
    update_rating_list filter
    table_sort_bind()

# get all current filter parameters (customer_id, employee_id, interval, from, to, order of feedback list) from page
filter_setup_variables = ->
  interval = $('a.button.interval.success').data('interval')
  time_filter = calculate_date_from_interval(interval)
  employee_id = if ($('#rating_employee').val() == "all") then "all" else $('#rating_employee').val()
  customer_id = if ($('#rating_customer').val() == "all") then "all" else $('#rating_customer').val()
  ratings_order = $('th a.created-at-sort').attr("val")

  {from: time_filter["from"], to: time_filter["to"], time_interval: interval, employee_id: employee_id, customer_id: customer_id, order: ratings_order}

# feedback list sorting change
table_sort_bind = ->
  $('th a.created-at-sort').bind('click', ->
    if $(this).attr("val") == "DESC"
      $(this).attr("val", "ASC")
    else
      $(this).attr("val", "DESC")

    filter = filter_setup_variables()
    update_rating_list filter
  )

# updates heading for current customer and current employee using localization
heading_update = () ->
  interval = $('a.button.interval.success').data('interval')
  time_filter = calculate_date_from_interval(interval)

  period = I18n.t "wall.all_period"
  period = I18n.t "wall.custom_period", from: time_filter['from'], to: time_filter['to'] if interval != 'all'

  customer = I18n.t "wall.all_customers"
  customer = I18n.t "wall.custom_customer", customer: $('#rating_customer option:selected').text() if $('#rating_customer option:selected').text() != I18n.t 'filter.all'

  employee = I18n.t "wall.all_employees"
  employee = I18n.t "wall.custom_employee", employee_name: $('#rating_employee option:selected').text() if $('#rating_employee option:selected').text() != I18n.t 'filter.all'

  $("h1.wall-heading").text(I18n.t "wall.statistics_intro", period: period, customer: customer, employee: employee)

# select current filtered employee and current filtered customer from select_list
select_init = () ->
  $("#rating_employee").val(urlParam('employee_id')) if urlParam('employee_id')
  $("#rating_customer").val(urlParam('customer_id')) if urlParam('customer_id')

# updates rating list
update_rating_list = (filter) ->
  $.ajax({
    cache: false
    type: "GET",
    dataType: "script",
    url: "/ratings",
    data: filter,
  }).done ->
    table_sort_bind()


# updates specific chart
update_chart = (type, filter) ->
  $.ajax({
    cache: false
    type: "GET",
    dataType: "script",
    url: "/graphs/" + type,
    data: filter,
  })


switch_statistics_button = (element) ->
  $('.time-switcher a.button').removeClass('success')
  $(element).addClass('success')

  switch $(element).attr("type")
    when "all"
      $(".statistics .data-filtered").hide()
      $(".statistics .data").show()
    when "filtered"
      $(".statistics .data").hide()
      $(".statistics .data-filtered").show()
    else
      throw new Error "Unknown statistic button clicked"
