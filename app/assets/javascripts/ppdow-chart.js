$(function () {
  var q = $("input[name='ppdow_q']:checked").val(),
      user_id = $("#ppdow-chart").data("user-id");
  if (!user_id) { return; }
  $.getJSON("/users/" + user_id + "/ppdow?q=" + q, function(data) {
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
        data: data
      }],
      plotOptions: {
        column: {
          borderWidth: 0
        }
      },
      title: "",
      legend: {
        enabled: false
      }
    });
  });
  $("input[name='ppdow_q']").on("change", function() {
    var q = $("input[name='ppdow_q']:checked").val();
    $.getJSON("/users/" + user_id + "/ppdow?q=" + q, function(data) {
      $("#ppdow-chart-container").highcharts().xAxis[0].series[0].setData(data);
    });
  });
});
