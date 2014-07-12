$(function() {
  var user_id = $("#pph-chart").data("user-id"),
      url;
  if (!$("#pph-chart").length) { return; }
  if (user_id) {
    url = "/users/" + user_id + "/pph";
  } else {
    url = "/stats/pph";
  }
  function pointClick(ev) {
    var points = ev.point.series.points,
        from = Highcharts.dateFormat("%d.%m.%Y", ev.point.x),
        to = Highcharts.
          dateFormat("%d.%m.%Y", points[points.indexOf(ev.point) + 1].x),
        url;
    if (user_id) {
      url = "/users/" + user_id + "/posts?posts_q[remote_created_at_gt]=" +
        from + "&posts_q[remote_created_at_lt]=" + to;
    } else {
      url = "/posts?posts_q[remote_created_at_gt]=" + from +
        "&posts_q[remote_created_at_lt]=" + to;
    }
    window.open(url, "_blank");
  }
  $.getJSON(url, function(data) {
    $("#pph-chart-container").highcharts("StockChart", {
      colors: ["#ffcf3e"],
      navigator: {
	series: {
	  data: data,
          color: "#ffcf3e",
          lineColor: "#f0b400"
        }
      },
      scrollbar: {
        enabled: false
      },
      plotOptions: {
        series: {
          marker: {
            radius: 3,
            fillColor: "#f0b400"
          },
          lineWidth: 3,
          dataGrouping: {
            groupPixelWidth: "20",
            approximation: "sum"
          },
          point: {
            events: {
              click: pointClick
            }
          }
        }
      },
      chart: {
        backgroundColor: "#ffe495",
	zoomType: "x",
        type: "spline"
      },
      rangeSelector: {
        enabled: false
      },
      series: [{
	data: data,
        name: "postov"
      }]
    });
    $("#pph-chart-container").highcharts().xAxis[0].
      setExtremes($("#pph-chart-container").highcharts().xAxis[0].max - 7776000000,
                  $("#pph-chart-container").highcharts().xAxis[0].max);
  });
});
