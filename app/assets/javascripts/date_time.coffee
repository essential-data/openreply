# to make functions global
root = exports ? this

# calculate interval from page selected interval
root.calculate_date_from_interval = (interval) ->
  from = new Date()
  to = new Date()
  switch interval
    when "all"
      return {
      from: ""
      to: ""
      interval: interval
      }

    when "week"
      from.setDate(from.getDate() - 7)
    when "month"
      from.setDate(from.getDate() - 31)
    when "year"
      from.setDate(from.getDate() - 365)
    when "custom"
      from = $('#datepickerModal #startDate').text()
      to = $('#datepickerModal #endDate').text()
      return {
      from: from
      to: to
      interval: interval
      }

  return {
  from: toFullDate(from)
  to: toFullDate(to)
  time_interval: interval
  }

root.toFullDate = (date) ->
  date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();


root.valid_date_time = ->
  if $('#datepickerModal #startDate').text() != "" && $('#datepickerModal #endDate').text() != ""
    true
  else
    false
