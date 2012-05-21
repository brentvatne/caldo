class IncompleteTodoView extends Backbone.View

  tagName: 'li'

  template: _.template($('#incomplete-todo-template').html())

  events: 'click input[type=checkbox]': 'markComplete'

  initialize: ->
    @className = 'todo'

    if @model.isImportant()
      @className = "#{@className} important"

    @setElement(@make(@tagName, class: @className))

  render: ->
    @$el.html @template(@model.toJSON())

  markComplete: ->
    @model.save(complete: true)


@Caldo = window.Caldo || {}
@Caldo.IncompleteTodoView = IncompleteTodoView
