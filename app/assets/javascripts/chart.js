$(function() {
  $("#ppdow-chart-buttons").buttonset();
  $("#pphod-chart-buttons").buttonset();

  var $ppdow_filter = $("#ppdow-chart-filter");
  var $pphod_filter = $("#pphod-chart-filter");

  function load_ppdow_chart() {
    var q = $ppdow_filter.find("input[name='ppdow_q']:checked").val(),
        user_id = $ppdow_filter.find("input[name='user_id']").val();
    $.get("/users/" + user_id + "/ppdow?q=" + q, function(html) {
      $("#ppdow-chart-container").html(html);
    });
    return false;
  }

  function load_pphod_chart() {
    var q = $pphod_filter.find("input[name='pphod_q']:checked").val(),
        user_id = $pphod_filter.find("input[name='user_id']").val();
    $.get("/users/" + user_id + "/pphod?q=" + q, function(html) {
      $("#pphod-chart-container").html(html);
    });
    return false;
  }

  if ($ppdow_filter.length == 1) {
    load_ppdow_chart();
    $ppdow_filter.on("submit", load_ppdow_chart);
  }

  if ($pphod_filter.length == 1) {
    load_pphod_chart();
    $pphod_filter.on("submit", load_pphod_chart);
  }
});
