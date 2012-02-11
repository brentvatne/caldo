$ ->
  class TodosView extends Backbone.View
    tagName: 'ul'
    className: 'todos'

    initialize: ->
      @collection.bind 'reset', @render, @
      $(".content-container").append(@el)

    render: ->
      $(@el).empty()
      for todo in @collection.models
        $(@el).append(new TodoView(model: todo).render())

  class TodoView extends Backbone.View
    tagName: 'li'
    className: 'todo'
    template: _.template($('#todo-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())

  @caldo = window.caldo || {}
  @caldo.TodosView = TodosView
