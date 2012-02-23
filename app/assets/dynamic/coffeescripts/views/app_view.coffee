class AppView extends Backbone.View
  id: 'caldo'

  # Initialize the TodosView (using preload data if it exists, otherwise no), and 
  # create collection bindings.
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

  # Sets the current date of the AppView to the day after the current date
  nextDay: (e) ->
    @setDate(Caldo.Util.nextDate(@date))
    e.preventDefault()

  # Sets the current date of the AppView to the day before the current date
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

  hideTodos: (callback) ->
    this.$el.fadeOut('fast', callback.bind(this))

  # Changes the date to the given date and cascades the change through
  # to the Todos collection. Also triggers the transition events to
  # change the given page.
  setDate: (newDate, options = {}) ->
    @date = newDate

    unless options.silent
      @hideTodos ->
        this.$el.find('.date').html(Caldo.Util.humanDate(@date))
        @collection.setDate(newDate)
        @showTodos()

@Caldo = window.Caldo || {}
@Caldo.AppView = AppView
