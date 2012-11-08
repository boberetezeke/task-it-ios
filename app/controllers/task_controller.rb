class TaskController < Formotion::FormController
  @@form_hash = {
    title: "",
    sections: [
      {
        title: "Task Info",
        rows: [
          {
            key: :name,
            type: :string,
            title: "Name",
            placeholder: "short description for task"
          },
          {
            key: :details,
            type: :text,
            title: "Details",
            row_height: 100,
            placeholder: "details about task"
          }
        ],
      },

      {
        title: "Assigned To",
        rows: [
          {
            key: :owner,
            type: :picker,
            title: "Name",
            items: []
          }
        ]
      }
    ]
  }

  attr_reader :form

  def initWithTask(task, new_task)
    @task = task
    @new_task = new_task
    @@form_hash[:title] = task.name
    @@form_hash[:sections][1][:rows][0][:items] = [""] + User.all.map{|u| u.name} 
    @user_ids = [nil] + User.all.map{|u| u.id}
    @form = Formotion::Form.new(@@form_hash)
    @form.fill_out( 
      :name => task.name, 
      :details => task.details,
      :owner => task.user ? task.user.name : "")

    self.initWithForm(form)
    self
  end

  def viewDidLoad
    super

    rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Save", style: UIBarButtonItemStylePlain, target: self, action: "savePressed")
    rightBarButtonItem.accessibilityLabel = "Save Button"
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
  end

  def savePressed
    @task.name = @form.render[:name]
    @task.details = @form.render[:details]
    user_name = @form.render[:owner]
    if user_name == "" then
      @task.user = nil
    else
      @task.user = User.where(:name).eq(user_name).first
    end
    url = "http://localhost:3000/tasks"
    task_hash = @task.to_hash
    task_hash.delete(:created_at)
    task_hash.delete(:updated_at)
    if @new_task then
      method = :post
      task_hash.delete(:id)
    else
      method = :put
      url += "/#{@task.id}"
    end
    @task.save

    BubbleWrap::HTTP.send(method, url, 
                           {payload: BW::JSON.generate(task_hash),
                            headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}}
    ) do |response|
      if response.ok?
        if response.body
          task_hash = BW::JSON.parse(response.body.to_str)
          if @new_task then
            @task.id = task_hash["id"]
            @task.save
          end
        end
      else
        puts "invalid request, response.status_code = #{response.inspect}"
      end
    end

    if self.navigationController
      self.navigationController.popViewControllerAnimated(true)
    end
  end
end
