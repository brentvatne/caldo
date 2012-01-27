$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
		var $todo         = $(this).parent('.todo');
		var todo_variable = $todo.data("data-variable");

		$todo.toggleClass('done');

		if (todo_variable) {
			create_modal_for($todo, send_complete_request);
		} else {
			send_complete_request($todo, null);
		}
  });

	var create_modal_for = (function($todo, callback) {
		callback($todo, null);
	});

	var send_complete_request = (function($todo, variable_input) {
    var todo_id        = $todo.data("event-id");
    var todo_date      = $todo.data("date");
		var todo_completed = !!$todo.find("input").attr("checked");

		var path = todo_completed ? '/todos/complete' : '/todos/incomplete';

    $.post(path, {
      id:   todo_id,
      date: todo_date,
			variable: variable_input
    }, function(success) {
			if (success == false) {
				$todo.toggleClass('done');
				$todo.find("input").attr("checked", false)
			}
    });
	});
});
