$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
    var this_id    = $(this).parent(".todo").data("event-id");
    var this_date  = $(this).parent(".todo").data("date");
    var $this_el   = $(".todos").find("[data-event-id='" + this_id +"']");
		var completed  = !!$(this).attr("checked");

		var complete_path   = '/todos/complete';
		var incomplete_path = '/todos/incomplete';
		var path = "";

		if (completed) {
			path = complete_path;	
		} else {
			path = incomplete_path;
		}

    $.post(path, {
      id:   this_id,
      date: this_date
    }, function(data) {
      console.log(data);
    });
    // must handle failure case
  });
});
