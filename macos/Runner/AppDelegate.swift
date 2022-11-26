import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()
  var controller: FlutterViewController?;
  var channels: [MessageChannel] = []
  var windowManager: WindowManager?;

  override init() {
    super.init();
    popover.behavior = NSPopover.Behavior.transient
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    let project = FlutterDartProject.init()
    self.controller = CustomWindow.init(project: project);
    (self.controller as! CustomWindow).setKey(key: "statusbar");
    self.channels.append(MessageChannel.init(controller: controller))
    self.channels.append(MessageChannel.init(controller: mainFlutterWindow?.contentViewController as! FlutterViewController?))
    popover.contentSize = NSSize(width: 360, height: 360)
    popover.contentViewController = self.controller
    statusBar = StatusBarController.init(popover)
    
    let overlayChannel = self.channels.first {$0.controller?.key == "overlay"}
    self.windowManager = WindowManager.init(channel: overlayChannel);
    super.applicationDidFinishLaunching(aNotification)
  }
}
