# Implement check and uncheck
# switch to: new caldo.AppView(date: @caldo.Util.extractDateFromURL() || @caldo.Util.todaysDate())

@caldo = window.caldo || {}

$ ->
  caldo.date = @caldo.Util.extractDateFromURL() || @caldo.Util.todaysDate()

  new caldo.AppView
  caldo.Todos.fetch()
