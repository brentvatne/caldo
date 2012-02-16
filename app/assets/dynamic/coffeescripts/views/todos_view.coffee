class TodosView extends Backbone.View
  tagName: 'ul'

  className: 'todos'

  initialize: ->
    @app = @options['app']
    @collection.on 'reset',  @render, this
    @collection.on 'change', @render, this
    $(".todos-wrapper").append(@el)

  render: ->
    @$el.empty()

    for todo in @collection.allOnDate(@app.date)
      klass = switch todo.isComplete()
        when true  then Caldo.CompleteTodoView
        when false then Caldo.IncompleteTodoView
      @$el.append(new klass(model: todo).render())

@Caldo = window.Caldo || {}
@Caldo.TodosView = TodosView
