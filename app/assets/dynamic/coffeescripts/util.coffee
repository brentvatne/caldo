Util =
  # Extracts the current date from the path
  #
  # Returns null if the last part of the path is not a date formatted
  # 2012-01-01, otherwise it returns that date as a string
  extractDateFromURL: (url) ->
    date_regexp = /^\d{4}-\d{2}-\d{2}$/
    url_part    = _.last((url || window.location.pathname).split('/'))
    if url_part? and date_regexp.test(url_part) then url_part else null

  # Returns todays date in the form 2012-01-01
  todaysDate: ->
    formatDate(moment())

  # Formats a given date in the form 2012-01-01
  #
  # Accepts a moment date object, Date object, or string
  shortDate: (date) ->
    moment(date).format("YYYY-MM-DD")


  # Formats a given date in the form "Monday, January 1st 2012"
  #
  # Accepts a moment date object, Date object, or string
  humanDate: (date) ->
    moment(date).add('days',1).format("dddd, MMMM Do YYYY")


@Caldo = window.Caldo || {}
@Caldo.Util = Util
