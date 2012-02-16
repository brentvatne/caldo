class AppView extends Backbone.View
  id: 'caldo'

  initialize: ->
    @date       = @options['date']
    preloadData = @options['preloadData']

    @setDate(@date, silent: true)
    @render()

    @collection.on 'reset', @showTodos, this
    new Caldo.TodosView(collection: @collection, app: this)
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


  setDate: (newDate, options = {}) ->
    @date = newDate
    @collection.setDate(newDate)

    unless options.silent
      @$el.fadeOut 'fast', =>
        @$el.find('.date').html(Caldo.Util.humanDate(@date))
        @showTodos()
      @collection.fetch()

@Caldo = window.Caldo || {}
@Caldo.AppView = AppView
