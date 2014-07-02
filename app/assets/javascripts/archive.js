$(function() {
  if ($("#date-slider").length == 0) { return; }
  $("#date-slider").slider({
    range: true,
    min: 1253941200,                  // day we started
    max: new Date().getTime() / 1000, // today
    step: 86400,                      // one day in seconds
    values: [
      $.datepicker.parseDate("dd.mm.yy",
                             $("#topics_q_last_post_remote_created_at_gteq").
                             val()) / 1000,
      $.datepicker.parseDate("dd.mm.yy",
                             $("#topics_q_last_post_remote_created_at_lteq").
                             val()) / 1000
    ],
    slide: function(ev, ui) {
      $("#topics_q_last_post_remote_created_at_gteq").
        val($.datepicker.formatDate("dd.mm.yy", new Date(ui.values[0] * 1000)));
      $("#topics_q_last_post_remote_created_at_lteq").
        val($.datepicker.formatDate("dd.mm.yy", new Date(ui.values[1] * 1000)));
    }
  });
  $("#topics_q_last_post_remote_created_at_lteq").datepicker({
    dateFormat: "dd.mm.yy"
  });
  $("#topics_q_last_post_remote_created_at_gteq").datepicker({
    dateFormat: "dd.mm.yy"
  });
  $("#archive-settings-toggle").on("click", function() {
    $("#archive-settings").toggle();
  });
});
