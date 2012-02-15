class AppView extends Backbone.View
  id: 'caldo'

  initialize: (date) ->
    $('.wrap').append(@el)
    @setDate(date, silent: true)
    @render()

    Caldo.Todos.on 'reset', @showTodos, this

    new TodosView(collection: Caldo.Todos)
    if Caldo.preloadData
      Caldo.Todos.reset(Caldo.preloadData)
    else
      Caldo.Todos.fetch()

  events:
    "click a.next-day": "nextDay"
    "click a.previous-day": "previousDay"

  nextDay: (e) ->
    @setDate(Caldo.Util.nextDate(Caldo.date))
    e.preventDefault()

  previousDay: (e) ->
    @setDate(Caldo.Util.previousDate(Caldo.date))
    e.preventDefault()

  template: _.template($('#caldo-app-template').html())

  render: ->
    @$el.append(@template(date: Caldo.date))

  toggleTodoVisibility: ->
    @$el.find('.todos-wrapper').fadeToggle()


  showTodos: ->
    @$el.fadeIn('fast')

  setDate: (date, options = {}) ->
    Caldo.date = date

    unless options.silent
      @$el.fadeOut 'fast', =>
        @$el.find('.date').html(Caldo.Util.humanDate(date))
      Caldo.Todos.fetch()

class TodosView extends Backbone.View
  tagName: 'ul'
  className: 'todos'

  initialize: ->
    @collection.on 'reset',  @render, this
    @collection.on 'change', @render, this
    $(".todos-wrapper").append(@el)

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
    @model.save(complete: true)


class CompleteTodoView extends Backbone.View
  tagName: 'li'

  className: 'todo complete'

  template: _.template($('#complete-todo-template').html())

  render: ->
    @$el.html @template(@model.toJSON())

  events: "click input[type=checkbox]": "markIncomplete"

  markIncomplete: ->
    @model.save(complete: false)

@Caldo = window.Caldo || {}
@Caldo.AppView = AppView
