$(function () {
  var q = $("input[name='pphod_q']:checked").val(),
      user_id = $("#pphod-chart").data("user-id");
  if (!user_id) { return; }
  function pointClick(ev) {
    window.open("/users/" + user_id +
                "/posts?posts_q[remote_created_at_hod_eq]=" + ev.point.x,
                "_blank");
  }
  $.getJSON("/users/" + user_id + "/pphod?q=" + q, function(data) {
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
        data: data
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
  $("input[name='pphod_q']").on("change", function() {
    var q = $("input[name='pphod_q']:checked").val();
    $.getJSON("/users/" + user_id + "/pphod?q=" + q, function(data) {
      $("#pphod-chart-container").highcharts().xAxis[0].series[0].setData(data);
    });
  });
});
