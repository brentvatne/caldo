$ ->
  class TodoList extends Backbone.View
    tagName: 'ul'
    className: 'todos'

    initialize: ->
      @collection.bind 'reset', @render, @
      $(".content-container").append(@el)

    render: ->
      $(@el).empty()
      for todo in @collection.models
        $(@el).append(new TodoRow(model: todo).render())

  class TodoRow extends Backbone.View
    tagName: 'li'
    className: 'todo'
    template: _.template($('#todo-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())

  @caldo = window.caldo || {}
  @caldo.TodoList = TodoList
