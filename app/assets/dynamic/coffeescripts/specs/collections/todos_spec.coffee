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

    describe "onDate", ->
      beforeEach ->
        @todos = Caldo.Todos.reset [
          { summary: "Celebrate new year",    date: "2011-12-31" },
          { summary: "Buy fish",              date: "2012-01-01" },
          { summary: "Pretend to go fishing", date: "2012-01-01" }
          { summary: "Buy chicken",           date: "2012-01-02" }
          { summary: "A Birthday!",           date: "2012-01-06" }
        ]

      it "returns todos on the given date", ->
        results = @todos.onDate("2012-01-01")
        first_todo = _.first(results)
        other_todo = _.last(results)

        expect(results.length).toEqual 2
        expect(first_todo.get('summary')).toEqual "Buy fish"
        expect(other_todo.get('summary')).toEqual "Pretend to go fishing"

      it "also returns todos that are within five days and important", ->
        _.last(@todos.models).set('important', true)
        results = @todos.onDate("2012-01-01")
        last_todo = _.last(results)

        expect(results.length).toEqual 3
        expect(last_todo.get('summary')).toEqual "A Birthday!"

      it "does not include todos that are important but occur before", ->
        _.first(@todos.models).set('important', true)
        results = @todos.onDate("2012-01-01")
        first_todo = _.first(results)

        expect(results.length).toEqual 2
        expect(first_todo).toNotBe "Celebrate new year"
