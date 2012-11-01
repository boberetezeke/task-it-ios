class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    tasksController = TasksController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(tasksController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
