@caldo = window.caldo || {}

describe "Util", ->

  describe "extractDateFromURL", ->

    it "gives the correct date", ->
			result = caldo.Util.extractDateFromURL('some/stuff/2012-01-01')
			expect(result).toEqual '2012-01-01'
