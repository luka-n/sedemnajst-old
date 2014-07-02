$(function() {
  $(".submittable").on("change", function() {
    $(this).parents("form").submit();
  });
});
