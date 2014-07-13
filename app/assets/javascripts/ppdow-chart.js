$(function () {
  var user_id = $("#ppdow-chart").data("user-id"),
      url;
  if (!$("#ppdow-chart").length) { return; }
  if (user_id) { url = "/users/" + user_id + "/ppdow"; }
  else { url = "/stats/ppdow"; }
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
  function reloadData() {
    var from = $("#ppdow_from").val(), to = $("#ppdow_to").val(), url;
    if (user_id) {
      url = "/users/" + user_id +
        "/ppdow?user_posts_by_dow_q[day_gt]=" + from +
        "&user_posts_by_dow_q[day_lt]=" + to;
    } else {
      url = "/stats/ppdow?posts_by_dow_q[day_gt]=" + from +
        "&posts_by_dow_q[day_lt]=" + to;
    }
    $.getJSON(url, function(json) {
      $("#ppdow-chart-container").highcharts().xAxis[0].series[0].
        setData(json.data);
    });
  }
  function clearButtons() {
    $("[name='ppdow_range']:checked").removeAttr("checked");
  }
  $.getJSON(url, function(json) {
    $("#ppdow_from").val($.datepicker.
                         formatDate("dd.mm.yy",
                                    new Date(json.from * 1000)));
    $("#ppdow_to").val($.datepicker.
                       formatDate("dd.mm.yy",
                                  new Date(json.to * 1000)));
    $("[name='ppdow_range']").on("change", function() {
      var range = $(this).val(),
          to = $("#ppdow-chart-slider").slider("option", "max"),
          from;
      if (range == "one_month") { from = to - 2592000; }
      else if (range == "three_months") { from = to - (3 * 2592000); }
      else if (range == "six_months") { from = to - (6 * 2592000); }
      else if (range == "one_year") { from = to - (12 * 2592000); }
      else if (range == "all_time") {
        from = $("#ppdow-chart-slider").slider("option", "min");
      }
      $("#ppdow-chart-slider").slider("values", [from, to]);
      $("#ppdow_from").val($.datepicker.
                           formatDate("dd.mm.yy",
                                      new Date(from * 1000)));
      $("#ppdow_to").val($.datepicker.
                         formatDate("dd.mm.yy",
                                    new Date(to * 1000)));
      reloadData();
    });
    $("#ppdow_from").datepicker({
      onSelect: function(date) {
        var from = $.datepicker.parseDate("dd.mm.yy", date).getTime() / 1000;
        $("#ppdow-chart-slider").slider("values", 0, from);
        clearButtons();
        reloadData();
      }
    });
    $("#ppdow_to").datepicker({
      onSelect: function(date) {
        var to = $.datepicker.parseDate("dd.mm.yy", date).getTime() / 1000;
        $("#ppdow-chart-slider").slider("values", 1, to);
        clearButtons();
        reloadData();
      }
    });
    $("#ppdow-chart-filter").css("visibility", "visible");
    $("#ppdow-chart-container").highcharts({
      colors: ["#ffcf3e"],
      chart: {
        backgroundColor: "#ffe495",
        type: "column",
        style: {
          fontFamily: "Verdana, sans-serif"
        }
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
        title: "",
        labels: {
          align: "left",
          x: 0,
          y: -2
        },
        showLastLabel: false
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
    $("#ppdow-chart-slider").slider({
      range: true,
      min: json.min,
      max: json.max,
      step: 86400,
      values: [json.from, json.to],
      slide: function(ev, ui) {
        var values = $("#ppdow-chart-slider").slider("values"),
            from = $.datepicker.
              formatDate("dd.mm.yy",
                         new Date(values[0] * 1000)),
            to = $.datepicker.
              formatDate("dd.mm.yy",
                         new Date(values[1] * 1000));
        $("#ppdow_from").val(from);
        $("#ppdow_to").val(to);
      },
      stop: function() {
        clearButtons();
        reloadData();
      }
    });
  });
});
