$(function() {
  var default_options = {
    library: {
      chart: {
        backgroundColor: "#ffeebb",
        zoomType: "x"
      },
      plotOptions: {
        series: {
          marker: {
            radius: 5,
            fillColor: '#F0B400',
            lineColor: '#ffcf3e'
          },
          lineWidth: 5,
          color: '#ffcf3e'
        },
        column: {
          borderWidth: 0
        }
      }
    }
  };

  $(".chart-filter").buttonset();

  function make_ppd_chart() {
    var user_id = $("#ppd-chart").data("user-id"),
        q = $("input[name='ppd_q']:checked").val(),
        url = "/users/" + user_id + "/ppd?q=" + q;
    $("#ppd-chart-container").html($("<div>", {class: "loader"}));
    new Chartkick.LineChart("ppd-chart-container", url, default_options);
  }

  function make_ppdow_chart() {
    var user_id = $("#ppdow-chart").data("user-id"),
        q = $("input[name='ppdow_q']:checked").val(),
        url = "/users/" + user_id + "/ppdow?q=" + q;
    $("#ppdow-chart-container").html($("<div>", {class: "loader"}));
    new Chartkick.ColumnChart("ppdow-chart-container", url, default_options);
  }

  function make_pphod_chart() {
    var user_id = $("#pphod-chart").data("user-id"),
        q = $("input[name='pphod_q']:checked").val(),
        url = "/users/" + user_id + "/pphod?q=" + q;
    $("#pphod-chart-container").html($("<div>", {class: "loader"}));
    new Chartkick.ColumnChart("pphod-chart-container", url, default_options);
  }

  if ($("#ppd-chart").length) { make_ppd_chart(); }
  if ($("#ppdow-chart").length) { make_ppdow_chart(); }
  if ($("#pphod-chart").length) { make_pphod_chart(); }

  $("input[name='ppd_q']").on("change", make_ppd_chart);
  $("input[name='ppdow_q']").on("change", make_ppdow_chart);
  $("input[name='pphod_q']").on("change", make_pphod_chart);
});
