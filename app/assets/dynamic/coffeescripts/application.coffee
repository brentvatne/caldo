@caldo = window.caldo || {}

$ ->
  new caldo.TodoList collection: caldo.Todos
  caldo.Todos.fetch()
