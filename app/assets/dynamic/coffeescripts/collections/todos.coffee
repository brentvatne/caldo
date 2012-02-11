$ ->
  class Todos extends Backbone.Collection
    initialize: () ->

    model: caldo.Todo

    complete: ->
      _.filter @models, (todo) -> todo.isComplete()

    incomplete: ->
      _.reject @models, (todo) -> todo.isComplete()

    important: ->
      _.filter @models, (todo) -> todo.isImportant()

    url: () -> '/todos/' + caldo.date

  @caldo = window.caldo || {}
  @caldo.Todos = new Todos
