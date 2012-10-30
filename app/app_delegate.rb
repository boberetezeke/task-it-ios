class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    user = User.create(:name => "steve")
    true
  end
end
