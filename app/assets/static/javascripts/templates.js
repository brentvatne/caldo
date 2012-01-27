$(function() {
	var variable_dialog_markup = "\
		<div class='variable-dialog' style='display:none'>\
			<h2>${variable_name}:</h2>\
			<input type='text'><a class='button big'>Save</a>\
		</div>\
	";
	$.template('title-variable-dialog', variable_dialog_markup);
});
