class AppView extends Backbone.View
  id: 'caldo'

  # Initialize the TodosView (using preload data if it exists, otherwise no), and 
  # create collection bindings.
  initialize: ->
    @date       = @options['date']
    preloadData = @options['preloadData']

    @initializeDate()
    @render()
    @enableKeyboardScrolling()

    @collection.on 'reset', @showTodos, this
    @collection.on 'reset', @hideLoading, this
    new Caldo.TodosView(collection: @collection, app: this)
    if preloadData then @collection.reset(preloadData) else @collection.fetch()



  events:
    "click .next-day":     "navigateToNextDay"
    "click .previous-day": "navigateToPreviousDay"
    "click .sync-button":  "synchronizeTodos"

  initializeDate: () ->
    @setDate(@date, silent: true)
    @collection.date = @date

  synchronizeTodos: (e) ->
    @displayLoading()
    @collection.fetch()

  displayLoading: ->
    $('.sync-button').addClass('spinning')

  hideLoading: ->
    $('.sync-button').removeClass('spinning')


  navigateToNextDay: (e) ->
    e?.preventDefault()
    Backbone.history.navigate(Caldo.Util.nextDate(@date))
    @nextDay()

  navigateToPreviousDay: (e) ->
    e?.preventDefault()
    Backbone.history.navigate(Caldo.Util.previousDate(@date))
    @previousDay()

  enableKeyboardScrolling: ->
    $('body').keydown (e) =>
      switch e.keyCode
        when 37 then @navigateToPreviousDay()
        when 39 then @navigateToNextDay()

  # Sets the current date of the AppView to the day after the current date
  nextDay: ->
    @setDate(Caldo.Util.nextDate(@date))

  # Sets the current date of the AppView to the day before the current date
  previousDay: ->
    @setDate(Caldo.Util.previousDate(@date))

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
    this.$el.fadeOut 'fast', =>
      callback.call(this)

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
