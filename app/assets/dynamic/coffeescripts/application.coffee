# Load the entire template
# Implement check and uncheck
# Implement important

@caldo = window.caldo || {}

$ ->
  new caldo.AppView
  caldo.Todos.fetch()
