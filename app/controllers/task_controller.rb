class TaskController < UIViewController
  def withTask(task)
    @task = task
    self
  end

  def loadView
    super
    
    title = UILabel.alloc.initWithFrame([[10,10], [self.view.bounds.size.width - 20, 20]])
    title.text = @task.name

    self.view.backgroundColor = UIColor.whiteColor
    self.view << title
  end
end
