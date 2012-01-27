$(function() {
  $(".notification").addClass("hidden");

  var toggle_complete = function(element) {
		element.toggleClass('done');
  };

  $("input.todo").click(function() {
		var $this_el   = $(this).parent('.todo')
    var this_id    = $this_el.data("event-id");
    var this_date  = $this_el.data("date");
		var completed  = !!$(this).attr("checked");

		var complete_path   = '/todos/complete';
		var incomplete_path = '/todos/incomplete';
		var path = "";

		toggle_complete($this_el);

		if (completed) {
			path = complete_path;	
		} else {
			path = incomplete_path;
		}

    $.post(path, {
      id:   this_id,
      date: this_date
    }, function(success) {
			if (success == true) {
				//done
			} else {
				toggle_complete($this_el.parent(".todo"));
			}
    });
  });
});
