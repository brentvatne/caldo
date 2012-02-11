$ ->
  Util =
    # Extracts the current date from the path
    #
    # Returns null if the last part of the path is not a date formatted
    # 2012-01-01, otherwise it returns that date as a string
    extractDateFromURL: ->
      _.last(window.location.pathname.split('/'))

    # Returns todays date in the form 2012-01-01
    todaysDate: ->
      formatDate(moment())

    # Formats a given date in the form 2012-01-01
    #
    # Accepts a moment date object or a Date object
    formatDate: (date) ->
      date.format("YYYY-MM-DD")

  @caldo = window.caldo || {}
  @caldo.Util = Util
