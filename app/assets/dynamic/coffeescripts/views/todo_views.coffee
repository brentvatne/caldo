$ ->
  class TodosView extends Backbone.View
    tagName: 'ul'
    className: 'todos'

    initialize: ->
      @collection.bind 'reset', @render, @
      $(".todo-list").append(@el)

    render: ->
      $(@el).empty()
      for todo in @collection.models
        klass = switch todo.isComplete()
          when true
            CompleteTodoView
          when false
            if todo.isImportant() then ImportantTodoView else IncompleteTodoView

        $(@el).append(new klass(model: todo).render())

  class IncompleteTodoView extends Backbone.View
    tagName: 'li'
    className: 'todo incomplete'
    template: _.template($('#incomplete-todo-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())

  class CompleteTodoView extends Backbone.View
    tagName: 'li'
    className: 'todo complete'
    template: _.template($('#complete-todo-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())

  class ImportantTodoView extends Backbone.View
    tagName: 'li'
    className: 'todo important'
    template: _.template($('#important-todo-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())

  @caldo = window.caldo || {}
  @caldo.TodosView = TodosView