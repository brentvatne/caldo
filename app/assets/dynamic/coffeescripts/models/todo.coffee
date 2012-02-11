$ ->
  class Todo extends Backbone.Model
    isComplete:  -> @get("complete")
    isImportant: -> @get("important")

  @caldo = window.caldo || {}
  @caldo.Todo = Todo
