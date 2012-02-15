class Todos extends Backbone.Collection
  initialize: () ->

  model: Caldo.Todo

  complete: ->
    _.filter @models, (todo) -> todo.isComplete()

  incomplete: ->
    _.reject @models, (todo) -> todo.isComplete()

  important: ->
    _.filter @models, (todo) -> todo.isImportant()

  url: () -> '/todos/' + @date

  setDate: (@date) ->

@Caldo = window.Caldo || {}
@Caldo.Todos = new Todos
