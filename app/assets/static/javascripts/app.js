$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
	var this_id = $(this).data("event-id");
	var this_el = $(".events").find("[data-event-id='" + this_id +"']");
	console.log(this_el);
  });
});
