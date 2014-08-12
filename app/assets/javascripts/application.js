// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dashboard.js.coffee
//= require foundation-datepicker
//= require jquery.raty
//= require i18n
//= require jquery.tablesorter
//= require_tree .

$(document).ready(function () {
    $('#flash').fadeOut(3000)
});

$(function () {
    $(document).foundation({
        reveal: {
            close_on_background_click: false
        }
    });
});

$(function () {
    $('#stars').raty({
        score: 0,
        number: 5,
        // cancel      : true,
        path: '/assets/blue',
        width: 'auto',
        hints: ['poor', 'fair', 'good', 'very good', 'excellent', 'extraordinary'],
        click: function (score, evt) {
            $('#rating_value').val(score);
        }
    });
});
$(function () {
    var startDate = new Date();
    var endDate = new Date();
    $('#dp4').fdatepicker()
        .on('changeDate', function (ev) {
            if (ev.date.valueOf() > endDate.valueOf()) {
                $('#alert').show().find('strong').text('The start date can not be greater then the end date');
            } else {
                $('#alert').hide();
                startDate = new Date(ev.date);
                $('#startDate').text($('#dp4').data('date'));
            }
            $('#dp4').fdatepicker('hide');
        });
    $('#dp5').fdatepicker()
        .on('changeDate', function (ev) {
            if (ev.date.valueOf() < startDate.valueOf()) {
                $('#alert').show().find('strong').text('The end date can not be less then the start date');
            } else {
                $('#alert').hide();
                endDate = new Date(ev.date);
                $('#endDate').text($('#dp5').data('date'));
            }
            $('#dp5').fdatepicker('hide');
        });
});