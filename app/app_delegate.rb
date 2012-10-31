class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    steve = User.create(:name => "steve")
    abbie = User.create(:name => "abbie")
    rosie = User.create(:name => "rosie")
    angie = User.create(:name => "angie")

    empty_dishwasher = Task.create(:name => "empty dishwasher", :user => {:id => abbie.id})
    rake_leaves = Task.create(:name => "rake leaves", :user => {:id => steve.id})
    feed_chibi = Task.create(:name => "feed chibi")

    tasksController = TasksController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(tasksController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
