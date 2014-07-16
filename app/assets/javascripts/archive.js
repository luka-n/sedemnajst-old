$(function() {
  if ($("#date-slider").length == 0) { return; }
  $("#date-slider").slider({
    range: true,
    min: $("#date-slider").data("min"),
    max: $("#date-slider").data("max"),
    step: 86400000,
    values: [
      +moment.utc($("#topics_q_last_post_remote_created_on_gteq").val(),
                  "DD.MM.YYYY"),
      +moment.utc($("#topics_q_last_post_remote_created_on_lteq").val(),
                  "DD.MM.YYYY")
    ],
    slide: function(ev, ui) {
      $("#topics_q_last_post_remote_created_on_gteq").
        val(moment.utc(ui.values[0]).format("DD.MM.YYYY"));
      $("#topics_q_last_post_remote_created_on_lteq").
        val(moment.utc(ui.values[1]).format("DD.MM.YYYY"));
    }
  });
  $("#topics_q_last_post_remote_created_on_gteq").datepicker({
    minDate: moment.utc($("#date-slider").data("min")).format("DD.MM.YYYY"),
    maxDate: moment.utc($("#date-slider").data("max")).format("DD.MM.YYYY"),
    onSelect: function(date) {
      $("#date-slider").slider("values", 0, +moment.utc(date, "DD.MM.YYYY"));
    }
  });
  $("#topics_q_last_post_remote_created_on_lteq").datepicker({
    minDate: moment.utc($("#date-slider").data("min")).format("DD.MM.YYYY"),
    maxDate: moment.utc($("#date-slider").data("max")).format("DD.MM.YYYY"),
    onSelect: function(date) {
      $("#date-slider").slider("values", 1, +moment.utc(date, "DD.MM.YYYY"));
    }
  });
  $("#archive-settings-toggle").on("click", function() {
    $("#archive-settings").toggle();
    return false;
  });
});
