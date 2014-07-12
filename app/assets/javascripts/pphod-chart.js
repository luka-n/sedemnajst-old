$(function () {
  var user_id = $("#pphod-chart").data("user-id"),
      url;
  if (!$("#pphod-chart").length) { return; }
  if (user_id) {
    url = "/users/" + user_id + "/pphod";
  } else {
    url = "/stats/pphod";
  }
  function pointClick(ev) {
    var values = $("#pphod-chart-slider").slider("values"),
        from = $.datepicker.formatDate("dd.mm.yy", new Date(values[0] * 1000)),
        to = $.datepicker.formatDate("dd.mm.yy", new Date(values[1] * 1000)),
        url;
    if (user_id) {
      url = "/users/" + user_id +
        "/posts?posts_q[remote_created_at_hod_eq]=" + ev.point.x +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    } else {
      url = "/posts?posts_q[remote_created_at_hod_eq]=" + ev.point.x +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    }
    window.open(url, "_blank");
  }
  $.getJSON(url, function(json) {
    var from = $.datepicker.formatDate("dd.mm.yy", new Date(json.min * 1000)),
        to = $.datepicker.formatDate("dd.mm.yy", new Date(json.max * 1000));
    $("#pphod-chart-from").html(from);
    $("#pphod-chart-to").html(to);
    $("#pphod-chart-slider").slider({
      range: true,
      min: json.min,              // first post
      max: json.max,              // today
      step: 86400,                // one day in seconds
      values: [json.min, json.max],
      slide: function(ev, ui) {
        var values = $("#pphod-chart-slider").slider("values"),
            from = $.datepicker.formatDate("dd.mm.yy", new Date(values[0] * 1000)),
            to = $.datepicker.formatDate("dd.mm.yy", new Date(values[1] * 1000));
        $("#pphod-chart-from").html(from);
        $("#pphod-chart-to").html(to);
      },
      stop: function(ev, ui) {
        var from = $.datepicker.formatDate("dd.mm.yy", new Date(ui.values[0] * 1000)),
            to = $.datepicker.formatDate("dd.mm.yy", new Date(ui.values[1] * 1000)),
            url;
        if (user_id) {
          url = "/users/" + user_id + "/pphod?user_posts_by_hod_q[day_gt]=" + from +
            "&user_posts_by_hod_q[day_lt]=" + to;
        } else {
          url = "/stats/pphod?posts_by_hod_q[day_gt]=" + from +
            "&posts_by_hod_q[day_lt]=" + to;
        }
        $.getJSON(url, function(json) {
          $("#pphod-chart-container").highcharts().xAxis[0].series[0].setData(json.data);
        });
      }
    });
    $("#pphod-chart-container").highcharts({
      colors: ["#ffcf3e"],
      chart: {
        backgroundColor: "#ffe495",
        type: "column"
      },
      xAxis: {
        categories: [
          "0",
          "1",
          "2",
          "3",
          "4",
          "5",
          "6",
          "7",
          "8",
          "9",
          "10",
          "11",
          "12",
          "13",
          "14",
          "15",
          "16",
          "17",
          "18",
          "19",
          "20",
          "21",
          "22",
          "23"
        ]
      },
      yAxis: {
        title: ""
      },
      series: [{
        data: json.data,
        name: "postov"
      }],
      plotOptions: {
        column: {
          borderWidth: 0
        },
        series: {
          point: {
            events: {
              click: pointClick
            }
          }
        }
      },
      title: "",
      legend: {
        enabled: false
      }
    });
  });
});
