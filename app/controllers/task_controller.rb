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
            items: ["One", "Two", "Three"]
          }
        ]
      }
    ]
  }

  def initWithTask(task)
    @task = task
    @@form_hash[:title] = task.name
    form = Formotion::Form.new(@@form_hash)
    form.fill_out :name => task.name, :owner => task.user.name
    self.initWithForm(form)
    self
  end

  def viewDidLoad
    super

    rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Save", style: UIBarButtonItemStylePlain, target: self, action: "savePressed")
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
  end

  def savePressed
    @task.name = render[:name]
    @task.user = User.find_by_name(render[:owner])
    @task.save
    popViewController
  end
end
