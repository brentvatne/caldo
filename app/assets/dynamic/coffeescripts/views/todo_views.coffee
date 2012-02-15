class AppView extends Backbone.View
  id: 'caldo'

  initialize: ->
    @date       = @options['date']
    preloadData = @options['preloadData']

    @setDate(@date, silent: true)
    @render()

    @collection.on 'reset', @showTodos, this
    new TodosView(collection: @collection, app: this)
    if preloadData then @collection.reset(preloadData) else @collection.fetch()

  events:
    "click a.next-day":     "nextDay"
    "click a.previous-day": "previousDay"

  nextDay: (e) ->
    @setDate(Caldo.Util.nextDate(@date))
    e.preventDefault()

  previousDay: (e) ->
    @setDate(Caldo.Util.previousDate(@date))
    e.preventDefault()

  template: _.template($('#caldo-app-template').html())

  render: ->
    $('.wrap').empty()
    $('.wrap').append(@el)
    @$el.append(@template(date: @date))

  toggleTodoVisibility: ->
    @$el.find('.todos-wrapper').fadeToggle()

  showTodos: ->
    @$el.fadeIn('fast')

  setDate: (date, options = {}) ->
    @date = date

    unless options.silent
      @$el.fadeOut 'fast', =>
        @$el.find('.date').html(Caldo.Util.humanDate(@date))
      @collection.setDate(@date)
      @collection.fetch()

class TodosView extends Backbone.View
  tagName: 'ul'
  className: 'todos'

  initialize: ->
    @app = @options['app']
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
