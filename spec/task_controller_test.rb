class TaskControllerFactory
  def initialize(task, new_task)
    @task_controller = TaskController.alloc.initWithTask(task, new_task)
  end

  def alloc
    self
  end
  
  def init
    @task_controller
  end
end

describe "Testing Task Controller" do
  extend  WebStub::SpecHelpers

  describe "having no tasks and one user" do
    before do
      stub_request(:post, "http://localhost:3000/tasks").
          to_return(body: '{"id": 10}', content_type: "application/json")
    end
   
    describe "setting up the form" do
      tests TaskControllerFactory.new(
        Task.new(name: ""), true)
      
      after do
        Task.delete_all
      end

      it "should have the form filled out correctly" do
        controller.form.render[:name].should == ""
        controller.form.fill_out(:name => "clean garage")
        controller.savePressed
        wait 0.5 do 
          Task.count.should == 1
          Task.first.name.should == "clean garage"
          Task.first.id.should == 10
        end
      end
    end
  end
end

