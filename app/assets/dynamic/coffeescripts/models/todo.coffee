class Todo extends Backbone.Model
  isComplete:  -> @get("complete")
  isImportant: -> @get("important")

  markComplete: ->

  markIncomplete: ->

@Caldo = window.Caldo || {}
@Caldo.Todo = Todo
