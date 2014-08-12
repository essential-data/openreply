# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/

root = exports ? this


$(document).ready ->
  select_init()
  employee_change_update_bind()
  customer_change_update_bind()
  time_interval_change_bind()
  detailed_statistic_switcher()
  table_sort_bind()
  reload_grapsh_bind()

  update_all_charts()

# bind employees' select list change
employee_change_update_bind = ->
  $('#rating_employee').change ->
    update_all_charts()
    update_chart("/ratings/related_customers")
    make_loading_select('#rating_customer')


# bind customer' select list change
customer_change_update_bind = ->
  $('#rating_customer').change ->
    update_all_charts()
    update_chart("/ratings/related_employees")
    make_loading_select('#rating_employee')

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

# handle [all|filtered] switch of detailed statistics
detailed_statistic_switcher = ->
  $('.time-switcher a.button').click ->
    switch_statistics_button this

# initialize all charts updating
this.update_all_charts = ->
  if $("h1.wall-heading").length
    heading_update()

  if $('#rating-bar-chart').length
    make_loading('#rating-bar-chart')
    update_chart("/graphs/bar")

  if $('#rating-histogram-chart').length
    make_loading('#rating-histogram-chart')
    update_chart("/graphs/histogram")

  if $('#detailed-statistics').length
    switch_statistics_button $('.time-switcher a.button[type=all]')
    update_chart("/graphs/detailed_statistics")

  if $('#rating-timeline-chart').length
    make_loading('#rating-timeline-chart')
    update_chart("/graphs/time_line")

  if $("#ratings-list").length
    make_loading('#table-data')
    update_chart("/ratings")

make_loading = (element) ->
  $(element).html('')
  $(element).addClass('loading')

make_loading_select = (element) ->
  option = $('<option></option>').attr("value", "option value").text(I18n.t("loading"));
  $(element).empty().append(option)

# get all current filter parameters (customer_id, employee_id, interval, from, to, order of feedback list) from page
filter_setup_variables = ->
  interval = $('a.button.interval.success').data('interval')
  time_filter = calculate_date_from_interval(interval)
  ratings_order = $('th a.created-at-sort').attr("val")
  page = $('#ratings-pagination .current').text().trim()
  hash = {from: time_filter["from"], to: time_filter["to"], time_interval: interval, order: ratings_order, page: page}

  employee_id = if ($('#rating_employee').val() != "all") then hash['employee_id'] = $('#rating_employee').val()
  customer_id = if ($('#rating_customer').val() != "all") then hash['customer_id'] = $('#rating_customer').val()

  hash

# feedback list sorting change
table_sort_bind = ->
  $(document).on('click', 'th a.created-at-sort', ->
    if $(this).attr("val") == "DESC"
      $(this).attr("val", "ASC")
    else
      $(this).attr("val", "DESC")

    update_chart('/ratings')
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

# updates specific chart
root.update_chart = (url) ->
  filter = filter_setup_variables()
  $.ajax({
    cache: false
    type: "GET",
    dataType: "script",
    url: url,
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

#bind reload graph button to reload and hide
reload_grapsh_bind = ->
  if $('#reload-graphs')
    $('#reload-graphs').bind('submit', ->
      update_all_charts()
      $('#reload-graphs').fadeOut(1000)
      false
    )
