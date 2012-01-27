$(function() {
  $(".notification").addClass("hidden");

  $("input.todo").click(function() {
		var $todo          = $(this).parent('.todo');
		var todo_variable  = $todo.data("variable");
		var todo_completed = !$todo.find("input").attr("checked");

		$todo.toggleClass('done');

		if (!todo_variable || todo_completed) {
			update_completeness_request($todo, null);
		} else {
			create_modal_for($todo, update_completeness_request);
		}
  });

	var create_modal_for = (function($todo, callback) {
		var template_data = { variable_name: $todo.data("variable") };

		$('.variable-dialog').remove();
		$.tmpl('title-variable-dialog', template_data).prependTo('body');
		$.modal($('.variable-dialog'));

		$('.variable-dialog .button').click(function() {
			var input_value = $(this).siblings('input').val();
			callback($todo, input_value);
			$.modal.close();
		});
		//need to hook into modal closing callback and if not sent, disable check
		//but so it does not fire with $.modal.close()
	});

	var update_completeness_request = (function($todo, variable_input) {
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
