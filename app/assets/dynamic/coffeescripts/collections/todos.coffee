class Todos extends Backbone.Collection
  initialize: () ->

  model: Caldo.Todo

  complete: ->
    _.filter @models, (todo) -> todo.isComplete()

  incomplete: ->
    _.reject @models, (todo) -> todo.isComplete()

  important: ->
    _.filter @models, (todo) -> todo.isImportant()

  url: () -> '/todos/' + @date

  setDate: (@date) ->

  # Public: Filters out models based on their date
  #
  # Returns all models that occur on the given date, or are important
  # and within five days
  allOnDate: (date) ->
    console.log date
    _.filter @models, (todo) =>
      todoDate = todo.get('date')
      todoDate == date or
        (todo.isImportant() and @upToFiveDaysLater(date, todoDate))

  upToFiveDaysLater: (date, otherDate) ->
    daysBetween = Caldo.Util.daysBetween(date, otherDate)
    daysBetween <= 5 and daysBetween > 0

@Caldo = window.Caldo || {}
@Caldo.Todos = new Todos
