$(function () {
  var user_id = $("#ppdow-chart").data("user-id"), url;
  if (!$("#ppdow-chart").length) { return; }
  if (user_id) { url = "/users/" + user_id + "/ppdow"; }
  else { url = "/stats/ppdow"; }
  function pointClick(ev) {
    var url;
    if (user_id) { url = "/users/" + user_id + "/posts"; }
    else { url = "/posts"; }
    url += "?posts_q[remote_created_on_dow_eq]=" + (ev.point.x + 1) +
      "&posts_q[remote_created_on_gteq]=" + $("#ppdow_from").val() +
      "&posts_q[remote_created_on_lteq]=" + $("#ppdow_to").val();
    window.open(url, "_blank");
  }
  function reloadData() {
    var url;
    if (user_id) {
      url = "/users/" + user_id + "/ppdow" +
        "?user_posts_by_dow_q[day_gteq]=" + $("#ppdow_from").val() +
        "&user_posts_by_dow_q[day_lteq]=" + $("#ppdow_to").val();
    } else {
      url = "/stats/ppdow" +
        "?posts_by_dow_q[day_gteq]=" + $("#ppdow_from").val() +
        "&posts_by_dow_q[day_lteq]=" + $("#ppdow_to").val();
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
    $("#ppdow_from").val(moment.utc(json.from).format("DD.MM.YYYY"));
    $("#ppdow_to").val(moment.utc(json.to).format("DD.MM.YYYY"));
    $("[name='ppdow_range']").on("change", function() {
      var range = $(this).val(), from;
      if (range == "one_month") { from = json.max - 2592000000; }
      else if (range == "three_months") { from = json.max - (3 * 2592000000); }
      else if (range == "six_months") { from = json.max - (6 * 2592000000); }
      else if (range == "one_year") { from = json.max - (12 * 2592000000); }
      else if (range == "all_time") { from = json.min; }
      $("#ppdow-chart-slider").slider("values", [from, json.max]);
      $("#ppdow_from").val(moment.utc(from).format("DD.MM.YYYY"));
      $("#ppdow_to").val(moment.utc(json.max).format("DD.MM.YYYY"));
      reloadData();
    });
    $("#ppdow_from").datepicker({
      minDate: moment.utc(json.from).format("DD.MM.YYYY"),
      maxDate: moment.utc(json.to).format("DD.MM.YYYY"),
      onSelect: function(date) {
        $("#ppdow-chart-slider").
          slider("values", 0, +moment.utc(date, "DD.MM.YYYY"));
        clearButtons();
        reloadData();
      }
    });
    $("#ppdow_to").datepicker({
      minDate: moment.utc(json.from).format("DD.MM.YYYY"),
      maxDate: moment.utc(json.to).format("DD.MM.YYYY"),
      onSelect: function(date) {
        $("#ppdow-chart-slider").
          slider("values", 1, +moment.utc(date, "DD.MM.YYYY"));
        clearButtons();
        reloadData();
      }
    });
    $("#ppdow-chart-filter").css("visibility", "visible");
    $("#ppdow-chart-container").highcharts({
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
      step: 86400000,
      values: [json.from, json.to],
      slide: function(ev, ui) {
        var values = $("#ppdow-chart-slider").slider("values");
        $("#ppdow_from").val(moment.utc(values[0]).format("DD.MM.YYYY"));
        $("#ppdow_to").val(moment.utc(values[1]).format("DD.MM.YYYY"));
      },
      stop: function() {
        clearButtons();
        reloadData();
      }
    });
  });
});
