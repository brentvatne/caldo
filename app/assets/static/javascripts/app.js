$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
    var this_id    = $(this).parent(".event").data("event-id");
    var this_date  = $(this).parent(".event").data("date");
    var start_date = $(this).parent(".event").data("start-date");
    var end_date   = $(this).parent(".event").data("end-date");
    var $this_el   = $(".events").find("[data-event-id='" + this_id +"']");

    $.post('/events/complete', {
      id: this_id,
      date: this_date,
      start_date: start_date,
      end_date:   end_date
    }, function(data) {
      console.log(data);
    });
    // must handle failure case
  });
});
