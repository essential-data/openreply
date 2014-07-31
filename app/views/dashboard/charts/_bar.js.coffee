# set values for proper graph bar rendering
if $('#rating-bar-chart').length
  $('#rating-bar-chart').removeClass 'loading'
  $('#rating-bar-chart').highcharts({
    chart: {
      type: 'bar',
    },
    credits: {
      enabled: false,
    },
    tooltip: {
      formatter: ->
        s = '<b>'+"Rated"+'</b>'
        s += '<br>'+this.y
        return s;
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
    colors: [
      '#f0cdcd',
      '#2dc835',
      '#1aadce',
      '#492970',
      '#f28f43',
      '#77a1e5',
      '#c42525',
      '#a6c96a'
    ],
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
      categories: [''],
      title: {
        style: { "display:none" },
        text: ""
      }
    },
    yAxis: {
      title: {
        style: { "display:none" },
        text: ""
      }
    },
    series: [
      {
        "name": "<%= t :not_rated %>",
        "data": [<%= @bar.not_rated %>]
      },
      {
        "name": "<%= t :rated %>",
        "data": [<%= @bar.ratings_count %>]
      }
    ]
  })



