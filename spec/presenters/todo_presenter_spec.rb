describe Caldo::TodoPresenter do
  let(:todo) { Todo.new(:summary => "hello *important*",
                        :date    => "2012-01-27 8:00PM") }
  describe "summary" do
    it "should not display the *important* tag" do
      todo.summary.should_not match(/\*important\*/)
    end
  end

  describe "date" do
    it "should only display the day" do
      todo.date.should eq("Friday")
    end
  end

  describe "time" do
    it "should display the time in the format: 8:00 PM" do
      todo.time.should eq("8:00 PM")
    end
  end
end
