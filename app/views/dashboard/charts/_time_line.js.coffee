if $('#rating-timeline-chart').length
  $('#rating-timeline-chart').removeClass 'loading'
  $('#rating-timeline-chart').highcharts({
      chart: {
          type: 'spline'
      },
      title: {
          text: ''
      },
      credits: {
          enabled: false,
      },
      colors: ['#1393ca'],

      xAxis: {
          title: {
              text: 'Date'
          },

          type: 'datetime',
          dateTimeLabelFormats: { # don't display the dummy year
              month: '%e. %b',
              year: '%b'
          }
      },
      yAxis: {
          title: {
              text: 'Rating'
          },
          min: 0
      },
      tooltip: {
          formatter: ->
              result = "<b>#{ this.series.name }</b><br/>#{ Highcharts.dateFormat("%e. %b '%y", this.x) }: #{ this.y } points";
      },
      legend: {
          enabled: false,
      },
      series: [
          {
              "name": "<%= t :rated %>",
              "data": <%= @time_line.data %>
          }]
  })

