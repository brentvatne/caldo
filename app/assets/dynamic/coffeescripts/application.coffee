# Load the entire template
# Implement check and uncheck
# Implement important

@caldo = window.caldo || {}

$ ->
  new caldo.TodosView(collection: caldo.Todos)
  caldo.Todos.fetch()
