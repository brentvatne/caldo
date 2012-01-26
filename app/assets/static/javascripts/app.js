$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
    var this_id    = $(this).parent(".event").data("event-id");
    var given_date = $(this).parent(".event").data("given-date");
    var start_date = $(this).parent(".event").data("start-date");
    var end_date   = $(this).parent(".event").data("end-date");
    var $this_el   = $(".events").find("[data-event-id='" + this_id +"']");

    $.post('/events/complete', {
      id: this_id,
      given_date: given_date,
      start_date: start_date,
      end_date:   end_date
    }, function(data) {
      console.log(data);
    });
    // must handle failure case
  });
});
