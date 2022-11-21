import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()
  var controller: FlutterViewController?;

  override init() {
    let project = FlutterDartProject.init()
    project.dartEntrypointArguments = ["custom"];
    self.controller = CustomWindow.init(project: project);

    popover.behavior = NSPopover.Behavior.transient //to make the popover hide when the user clicks outside of it
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    popover.contentSize = NSSize(width: 360, height: 360) //change this to your desired size
    popover.contentViewController = self.controller //set the content view controller for the popover to flutter view controller
    statusBar = StatusBarController.init(popover)

    // mainFlutterWindow.close() //close the default flutter window

    super.applicationDidFinishLaunching(aNotification)
  }
}