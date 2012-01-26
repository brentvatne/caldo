$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
    var this_id = $(this).data("event-id");
    var $this_el = $(".events").find("[data-event-id='" + this_id +"']");
    $.get('/events/' + this_id + '/complete', function(data) {
      console.log(data);
    });
  });
});
