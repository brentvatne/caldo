describe "Todos collection", ->

  describe "scopes", ->
    beforeEach ->
      @todos = Caldo.Todos.reset [
        { important: true,  complete: true },
        { important: true,  complete: true }
        { important: true,  complete: false }
      ]

    describe "incomplete", ->
      it "returns all incomplete tasks", ->
        expect(@todos.incomplete().length).toEqual 1

    describe "complete", ->
      it "returns all complete tasks", ->
        expect(@todos.complete().length, 2).toEqual 2

    describe "important", ->
      it "returns all important tasks", ->
        expect(@todos.important().length).toEqual 3
