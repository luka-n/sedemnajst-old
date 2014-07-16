$(function () {
  var user_id = $("#pphod-chart").data("user-id"), url;
  if (!$("#pphod-chart").length) { return; }
  if (user_id) { url = "/users/" + user_id + "/pphod"; }
  else { url = "/stats/pphod"; }
  function pointClick(ev) {
    var url;
    if (user_id) { url = "/users/" + user_id + "/posts"; }
    else { url = "/posts"; }
    url += "?posts_q[remote_created_at_hod_eq]=" + ev.point.x +
      "&posts_q[remote_created_on_gteq]=" + $("#pphod_from").val() +
      "&posts_q[remote_created_on_lteq]=" + $("#pphod_to").val();
    window.open(url, "_blank");
  }
  function reloadData() {
    var url;
    if (user_id) {
      url = "/users/" + user_id + "/pphod" +
        "?user_posts_by_hod_q[day_gteq]=" + $("#pphod_from").val() +
        "&user_posts_by_hod_q[day_lteq]=" + $("#pphod_to").val();
    } else {
      url = "/stats/pphod" +
        "?posts_by_hod_q[day_gteq]=" + $("#pphod_from").val() +
        "&posts_by_hod_q[day_lteq]=" + $("#pphod_to").val();
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
    $("#pphod_from").val(moment.utc(json.from).format("DD.MM.YYYY"));
    $("#pphod_to").val(moment.utc(json.to).format("DD.MM.YYYY"));
    $("[name='pphod_range']").on("change", function() {
      var range = $(this).val(), from;
      if (range == "one_month") { from = json.max - 2592000000; }
      else if (range == "three_months") { from = json.max - (3 * 2592000000); }
      else if (range == "six_months") { from = json.max - (6 * 2592000000); }
      else if (range == "one_year") { from = json.max - (12 * 2592000000); }
      else if (range == "all_time") { from = json.min; }
      $("#pphod-chart-slider").slider("values", [from, json.max]);
      $("#pphod_from").val(moment.utc(from).format("DD.MM.YYYY"));
      $("#pphod_to").val(moment.utc(json.max).format("DD.MM.YYYY"));
      reloadData();
    });
    $("#pphod_from").datepicker({
      minDate: moment.utc(json.from).format("DD.MM.YYYY"),
      maxDate: moment.utc(json.to).format("DD.MM.YYYY"),
      onSelect: function(date) {
        $("#pphod-chart-slider").
          slider("values", 0, +moment.utc(date, "DD.MM.YYYY"));
        clearButtons();
        reloadData();
      }
    });
    $("#pphod_to").datepicker({
      minDate: moment.utc(json.from).format("DD.MM.YYYY"),
      maxDate: moment.utc(json.to).format("DD.MM.YYYY"),
      onSelect: function(date) {
        $("#pphod-chart-slider").
          slider("values", 1, +moment.utc(date, "DD.MM.YYYY"));
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
          "23"
        ]
      },
      yAxis: {
        title: "",
        offset: 24,
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
      step: 86400000,
      values: [json.from, json.to],
      slide: function(ev, ui) {
        var values = $("#pphod-chart-slider").slider("values");
        $("#pphod_from").val(moment.utc(values[0]).format("DD.MM.YYYY"));
        $("#pphod_to").val(moment.utc(values[1]).format("DD.MM.YYYY"));
      },
      stop: function() {
        clearButtons();
        reloadData();
      }
    });
  });
});
