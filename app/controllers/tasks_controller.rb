class TasksController < UIViewController
  def loadView
    super
    @tableView = UITableView.alloc.initWithFrame(self.view.bounds)
    @tableView.dataSource = @tableView.delegate = self

    self.view << @tableView
  end

  def tableView(tableView, numberOfRowsInSection: section)
    return Task.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cellIdentifier = "TaskCell"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: cellIdentifier) unless cell
    cell.textLabel.text = Task.all[indexPath.row].name
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    task = Task.all[indexPath.row]
    taskController = TaskController.alloc.init.withTask(task)
    navigationController.pushViewController(taskController, animated: true)
  end
end
