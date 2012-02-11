class Todo extends Backbone.Model
  isComplete:  -> @get("complete")
  isImportant: -> @get("important")

@Caldo = window.Caldo || {}
@Caldo.Todo = Todo
