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
    self.title = "Tasks"
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
    end
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    task = Task.all[indexPath.row]
    taskController = TaskController.alloc.initWithTask(task)
    navigationController.pushViewController(taskController, animated: true)
  end

  def dataDidChange(notification)
    if notification.object.is_a?(Task)
      NSLog "a task changed, user info = #{notification.userInfo.inspect}"
    end
  end
end
