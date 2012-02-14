class AppView extends Backbone.View
  id: 'caldo'

  initialize: ->
    $('.wrap').append(@el)
    new TodosView(collection: Caldo.Todos)

  setDate: (@date) ->

class TodosView extends Backbone.View
  tagName: 'ul'
  className: 'todos'

  initialize: ->
    @collection.on 'reset', @render, this
    $("#caldo").append(@el)

  render: ->
    @$el.empty()

    for todo in @collection.models
      klass = switch todo.isComplete()
        when true  then CompleteTodoView
        when false then IncompleteTodoView
      @$el.append(new klass(model: todo).render())


class IncompleteTodoView extends Backbone.View
  initialize: ->
    @className = if @options['model'].isImportant() then 'todo important' else 'todo incomplete'
    @setElement(@make(@tagName, class: @className))

  tagName: 'li'

  template: _.template($('#incomplete-todo-template').html())

  render: ->
    @$el.html @template(@model.toJSON())

  events: "click input[type=checkbox]": "markComplete"

  markComplete: ->
    @model.set(complete: true)
    @model.save()


class CompleteTodoView extends Backbone.View
  tagName: 'li'

  className: 'todo complete'

  template: _.template($('#complete-todo-template').html())

  render: ->
    @$el.html @template(@model.toJSON())

  events: "click input[type=checkbox]": "markIncomplete"

  markIncomplete: ->
    console.log "mark incomplete.."

@Caldo = window.Caldo || {}
@Caldo.AppView = AppView
