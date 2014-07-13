$(function () {
  var user_id = $("#pphod-chart").data("user-id"),
      url;
  if (!$("#pphod-chart").length) { return; }
  if (user_id) { url = "/users/" + user_id + "/pphod"; }
  else { url = "/stats/pphod"; }
  function pointClick(ev) {
    var values = $("#pphod-chart-slider").slider("values"),
        from = $.datepicker.formatDate("dd.mm.yy", new Date(values[0] * 1000)),
        to = $.datepicker.formatDate("dd.mm.yy", new Date(values[1] * 1000)),
        url;
    if (user_id) {
      url = "/users/" + user_id +
        "/posts?posts_q[remote_created_at_hod_eq]=" + (ev.point.x + 1) +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    } else {
      url = "/posts?posts_q[remote_created_at_hod_eq]=" + (ev.point.x + 1) +
        "&posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    }
    window.open(url, "_blank");
  }
  function reloadData() {
    var from = $("#pphod_from").val(), to = $("#pphod_to").val(), url;
    if (user_id) {
      url = "/users/" + user_id +
        "/pphod?user_posts_by_hod_q[day_gt]=" + from +
        "&user_posts_by_hod_q[day_lt]=" + to;
    } else {
      url = "/stats/pphod?posts_by_hod_q[day_gt]=" + from +
        "&posts_by_hod_q[day_lt]=" + to;
    }
    $.getJSON(url, function(json) {
      $("#pphod-chart-container").highcharts().xAxis[0].series[0].
        setData(json.data);
    });
  }
  function clearButtons() {
    $("[name='pphod_range']:checked").removeAttr("checked");
  }
  $.getJSON(url, function(json) {
    $("#pphod_from").val($.datepicker.
                         formatDate("dd.mm.yy",
                                    new Date(json.from * 1000)));
    $("#pphod_to").val($.datepicker.
                       formatDate("dd.mm.yy",
                                  new Date(json.to * 1000)));
    $("[name='pphod_range']").on("change", function() {
      var range = $(this).val(),
          to = $("#pphod-chart-slider").slider("option", "max"),
          from;
      if (range == "one_month") { from = to - 2592000; }
      else if (range == "three_months") { from = to - (3 * 2592000); }
      else if (range == "six_months") { from = to - (6 * 2592000); }
      else if (range == "one_year") { from = to - (12 * 2592000); }
      else if (range == "all_time") {
        from = $("#pphod-chart-slider").slider("option", "min");
      }
      $("#pphod-chart-slider").slider("values", [from, to]);
      $("#pphod_from").val($.datepicker.
                           formatDate("dd.mm.yy",
                                      new Date(from * 1000)));
      $("#pphod_to").val($.datepicker.
                         formatDate("dd.mm.yy",
                                    new Date(to * 1000)));
      reloadData();
    });
    $("#pphod_from").datepicker({
      onSelect: function(date) {
        var from = $.datepicker.parseDate("dd.mm.yy", date).getTime() / 1000;
        $("#pphod-chart-slider").slider("values", 0, from);
        clearButtons();
        reloadData();
      }
    });
    $("#pphod_to").datepicker({
      onSelect: function(date) {
        var to = $.datepicker.parseDate("dd.mm.yy", date).getTime() / 1000;
        $("#pphod-chart-slider").slider("values", 1, to);
        clearButtons();
        reloadData();
      }
    });
    $("#pphod-chart-filter").css("visibility", "visible");
    $("#pphod-chart-container").highcharts({
      credits: {
        enabled: false
      },
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
          "23",
          "24"
        ]
      },
      yAxis: {
        offset: 24,
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
    $("#pphod-chart-slider").slider({
      range: true,
      min: json.min,
      max: json.max,
      step: 86400,
      values: [json.from, json.to],
      slide: function(ev, ui) {
        var values = $("#pphod-chart-slider").slider("values"),
            from = $.datepicker.
              formatDate("dd.mm.yy",
                         new Date(values[0] * 1000)),
            to = $.datepicker.
              formatDate("dd.mm.yy",
                         new Date(values[1] * 1000));
        $("#pphod_from").val(from);
        $("#pphod_to").val(to);
      },
      stop: function() {
        clearButtons();
        reloadData();
      }
    });
  });
});
