$ ->
  date = Caldo.Util.extractDateFromURL() || Caldo.Util.todaysDate()

  new Caldo.AppView(date: date, collection: Caldo.Todos, preloadData: Caldo.preloadData)
