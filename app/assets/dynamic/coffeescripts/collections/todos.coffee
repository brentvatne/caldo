$ ->
  class Todos extends Backbone.Collection
    initialize: () ->

    model: caldo.Todo

    url: () -> '/todos/' + caldo.date

  @caldo = window.caldo || {}
  @caldo.Todos = new Todos
  @caldo.date = moment().format("YYYY-MM-DD")
