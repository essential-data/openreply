if $('#rating-histogram-chart').length
  $('#rating-histogram-chart').removeClass 'loading'
  $('#rating-histogram-chart').highcharts({
    chart: {
      type: 'column',
    },
    credits: {
      enabled: false,
    },
    tooltip: {
      formatter: ->
        s = '<b>'+"Ratings"+'</b>'
        s += '<br>'+this.y
        return s
    },
    title: {
      text: '',
      style: {
        display: 'none'
      }
    },
    subtitle: {
      text: '',
      style: {
        display: 'none'
      }
    },

    colors: ['#1393ca'],
    legend: {
      backgroundColor: '#FFFFFF',
      reversed: true
    },
    plotOptions: {
      series: {
        stacking: 'normal'
      }
    },
    xAxis: {
      title: {
        text: 'Rating',

      }
    },
    yAxis: {
      title: {
        text: 'Occurrence'
      },
    },
    legend: {
      enabled: false
    },

    series: [
      {
        "name": "<%= t :rated %>",
        "data": <%= @histogram.data %>
      }
    ]
  });

