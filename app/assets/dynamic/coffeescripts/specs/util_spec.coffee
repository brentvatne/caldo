describe "Util", ->

  describe "extractDateFromURL", ->
    it "returns null if last url part is not a date in the correct format", ->
      result = Caldo.Util.extractDateFromURL('some/stuff')
      expect(result).toEqual null


    it "gives the correct date", ->
			result = Caldo.Util.extractDateFromURL('some/stuff/2012-01-01')
			expect(result).toEqual '2012-01-01'

  describe "humanDate", ->
    it "turns a string from '2012-01-01' to Sunday, January 1st 2012", ->
      result = Caldo.Util.humanDate('2012-01-01')
      expect(result).toEqual 'Sunday, January 1st 2012'
