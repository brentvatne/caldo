$ ->
  Caldo.date = Caldo.Util.extractDateFromURL() || Caldo.Util.todaysDate()

  new Caldo.AppView

  if Caldo.preloadData
    Caldo.Todos.reset(Caldo.preloadData)
  else
    Caldo.Todos.fetch()
