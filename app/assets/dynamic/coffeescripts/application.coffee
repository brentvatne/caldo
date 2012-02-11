# Implement check and uncheck
# switch to: new caldo.AppView(date: @caldo.Util.extractDateFromURL() || @caldo.Util.todaysDate())

$ ->
  Caldo.date = Caldo.Util.extractDateFromURL() || Caldo.Util.todaysDate()

  new Caldo.AppView
  Caldo.Todos.fetch()
