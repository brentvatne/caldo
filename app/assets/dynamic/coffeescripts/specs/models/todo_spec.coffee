describe "Todo model", ->

  describe "state query methods", ->

    describe "isImportant", ->
      it "returns true if important", ->
        todo = new Caldo.Todo important: true
        expect(todo.isImportant()).toBeTruthy()

      it "returns false if not important", ->
        todo = new Caldo.Todo important: false
        expect(todo.isImportant()).toBeFalsy()

    describe "isComplete", ->
      it "returns true if complete", ->
        todo = new Caldo.Todo complete: true
        expect(todo.isComplete()).toBeTruthy()

      it "returns false if not important", ->
        todo = new Caldo.Todo complete: false
        expect(todo.isComplete()).toBeFalsy()
