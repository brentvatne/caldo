# Implement check and uncheck
# switch to: new caldo.AppView(date: @caldo.Util.extractDateFromURL() || @caldo.Util.todaysDate())

$ ->
  Caldo.date = Caldo.Util.extractDateFromURL() || Caldo.Util.todaysDate()

  new Caldo.AppView

  if Caldo.preloadData
    Caldo.Todos.reset(Caldo.preloadData)
  else
    Caldo.Todos.fetch()
