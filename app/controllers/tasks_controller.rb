class TasksController < UIViewController

  layout :root do
    subview(UIView, position: :relative, dimensions: [UIView::MAX_DIMENSION, 50], backgroundColor: UIColor.lightGrayColor) do
      @segmented_control = subview(UISegmentedControl.alloc.initWithItems(["My Tasks", "All Tasks"]), position: :relative, dimensions: UIView::MAX_DIMENSIONS, margins: [20, 20, 10, 10])
    end

    @tableView = subview(UITableView, position: :relative, dimensions: UIView::MAX_DIMENSIONS)
  end

  def viewDidLoad
    super 
    @tableView.dataSource = @tableView.delegate = self
    @segmented_control.selectedSegmentIndex = 0
    rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("New Task", style: UIBarButtonItemStylePlain, target: self, action: "newTaskPressed")
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
    self.title = "Tasks"

    BubbleWrap::HTTP.get("http://localhost:3000/users", 
                           {headers: {'Accept' => 'application/json'}}
    ) do |response|
      users_json_hash = BW::JSON.parse(response.body.to_str)
      puts "users json hash = #{users_json_hash}"
      users_json_hash.each do |user_json_hash|
        User.create(user_json_hash.dup)
      end

      BubbleWrap::HTTP.get("http://localhost:3000/tasks", 
                           {headers: {'Accept' => 'application/json'}}
      ) do |response|
        tasks_json_hash = BW::JSON.parse(response.body.to_str)
        puts "tasks json hash = #{tasks_json_hash}"
        tasks_json_hash.each do |task_json_hash|
          Task.create(task_json_hash.dup)
        end
        performSelector("updateView", withObject:nil, afterDelay:0.1)
      end
    end
  end

  def updateView
    @tableView.reloadData
  end

  def viewWillAppear(animated)
    super
    @tableView.reloadData
  end

  def viewDidAppear(animated)
    super
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'dataDidChange:', name:'MotionModelDataDidChangeNotification', object:nil)
  end

  def viewDidDisappear(animated)
    super
    NSNotificationCenter.defaultCenter.removeObserver self
  end

  def tableView(tableView, numberOfRowsInSection: section)
    return Task.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cellIdentifier = "TaskCell"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: cellIdentifier) unless cell
  
    task = Task.all[indexPath.row]
    cell.textLabel.text = task.name
    if task.user
      cell.detailTextLabel.text = task.user.name
    else
      cell.detailTextLabel.text = ""
    end
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    task = Task.all[indexPath.row]
    taskController = TaskController.alloc.initWithTask(task, false)
    navigationController.pushViewController(taskController, animated: true)
  end

  def newTaskPressed
    task = Task.new
    taskController = TaskController.alloc.initWithTask(task, true)
    navigationController.pushViewController(taskController, animated: true)
  end

  def dataDidChange(notification)
    if notification.object.is_a?(Task)
      NSLog "a task changed, user info = #{notification.userInfo.inspect}"
    #elsif notification.object.is_a?(User)
    #  NSLog "a user changed, user info = #{notification.userInfo.inspect}"
    end
  end
end
