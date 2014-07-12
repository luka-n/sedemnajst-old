$(function () {
  var user_id = $("#ppdow-chart").data("user-id"),
      url;
  if (!$("#ppdow-chart").length) { return; }
  if (user_id) {
    url = "/users/" + user_id + "/ppdow";
  } else {
    url = "/stats/ppdow";
  }
  function pointClick(ev) {
    var values = $("#ppdow-chart-slider").slider("values"),
        from = $.datepicker.formatDate("dd.mm.yy", new Date(values[0] * 1000)),
        to = $.datepicker.formatDate("dd.mm.yy", new Date(values[1] * 1000)),
        url;
    if (user_id) {
      url = "/users/" + user_id +
        "/posts?posts_q[remote_created_on_dow_eq]=" + (ev.point.x + 1) +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    } else {
      url = "/posts?posts_q[remote_created_on_dow_eq]=" + (ev.point.x + 1) +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    }
    window.open(url, "_blank");
  }
  $.getJSON(url, function(json) {
    var from = $.datepicker.formatDate("dd.mm.yy", new Date(json.min * 1000)),
        to = $.datepicker.formatDate("dd.mm.yy", new Date(json.max * 1000));
    $("#ppdow-chart-from").html(from);
    $("#ppdow-chart-to").html(to);
    $("#ppdow-chart-slider").slider({
      range: true,
      min: json.min,              // first post
      max: json.max,              // today
      step: 86400,                // one day in seconds
      values: [json.min, json.max],
      slide: function(ev, ui) {
        var values = $("#ppdow-chart-slider").slider("values"),
            from = $.datepicker.formatDate("dd.mm.yy", new Date(values[0] * 1000)),
            to = $.datepicker.formatDate("dd.mm.yy", new Date(values[1] * 1000));
        $("#ppdow-chart-from").html(from);
        $("#ppdow-chart-to").html(to);
      },
      stop: function(ev, ui) {
        var from = $.datepicker.formatDate("dd.mm.yy", new Date(ui.values[0] * 1000)),
            to = $.datepicker.formatDate("dd.mm.yy", new Date(ui.values[1] * 1000)),
            url;
        if (user_id) {
          url = "/users/" + user_id + "/ppdow?user_posts_by_dow_q[day_gt]=" + from +
            "&user_posts_by_dow_q[day_lt]=" + to;
        } else {
          url = "/stats/ppdow?posts_by_dow_q[day_gt]=" + from +
            "&posts_by_dow_q[day_lt]=" + to;
        }
        $.getJSON(url, function(json) {
          $("#ppdow-chart-container").highcharts().xAxis[0].series[0].setData(json.data);
        });
      }
    });
    $("#ppdow-chart-container").highcharts({
      colors: ["#ffcf3e"],
      chart: {
        backgroundColor: "#ffe495",
        type: "column"
      },
      xAxis: {
        categories: [
          "pon",
          "tor",
          "sre",
          "čet",
          "pet",
          "sob",
          "ned"
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
