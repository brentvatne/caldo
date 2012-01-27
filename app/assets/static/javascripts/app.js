$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
    var this_id    = $(this).parent(".todo").data("event-id");
    var this_date  = $(this).parent(".todo").data("date");
    var $this_el   = $(".todos").find("[data-event-id='" + this_id +"']");

    $.post('/todos/complete', {
      id:   this_id,
      date: this_date
    }, function(data) {
      console.log(data);
    });
    // must handle failure case
  });
});
