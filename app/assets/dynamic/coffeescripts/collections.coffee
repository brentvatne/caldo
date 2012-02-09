class Todos extends Backbone.Collection
  model: app.Todo
  url: '/todos/2012-01-01'

@app = window.app || {}
@app.Todos = new Todos
