$ ->
  date = Caldo.Util.extractDateFromURL() || Caldo.Util.todaysDate()

  new Caldo.AppView(date)
