describe "Testing Tasks Controller" do

  extend  WebStub::SpecHelpers

  before do
    @task1 = {created_at:"2012-11-01T06:14:35Z",details:"",id:1,name:"clean garage",updated_at:"2012-11-01T06:14:35Z",user_id:1}
    @user1 = {created_at:"2012-11-01T05:56:15Z",email_address:"",id:1,name:"Abbie",updated_at:"2012-11-01T05:56:15Z"}

    @task1_json = BubbleWrap::JSON::generate(@task1)
    @user1_json = BubbleWrap::JSON::generate(@user1)
  end

  describe "having no tasks and one user" do
    before do
      stub_request(:get, "http://localhost:3000/users").
          to_return(body: "[#{@user1_json}]", content_type: "application/json")
      stub_request(:get, "http://localhost:3000/tasks").
          to_return(body: "[]", content_type: "application/json")
    end

    describe "looking at the task table" do
      tests TasksController

      before do 
        @tasks_table = view("tasks table")
      end

      it "should have zero rows if zero tasks returned from server" do
        wait 0.5 do 
          @tasks_table.dataSource.tableView(@tasks_table, numberOfRowsInSection: 0).should == 0
        end
      end
    end
  end

  describe "having one task and one user" do
    before do
      stub_request(:get, "http://localhost:3000/users").
          to_return(body: "[#{@user1_json}]", content_type: "application/json")
      stub_request(:get, "http://localhost:3000/tasks").
          to_return(body: "[#{@task1_json}]", content_type: "application/json")
    end

    describe "looking at the task table" do
      tests TasksController

      before do 
        @tasks_table = view("tasks table")
      end

      it "should have one row if one task returned from server" do
        wait 0.5 do 
          @tasks_table.dataSource.tableView(@tasks_table, numberOfRowsInSection: 0).should == 1
          cell = @tasks_table.dataSource.tableView(@tasks_table, cellForRowAtIndexPath: NSIndexPath.alloc.indexPathByAddingIndex(0).indexPathByAddingIndex(0))
          cell.textLabel.text.should == "clean garage"
          cell.detailTextLabel.text.should == "Abbie"
        end
      end
    end
  end
end
