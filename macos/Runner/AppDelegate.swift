import Foundation
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
    
  @objc func onUpdateAccentColor(_ notification: Notification) {
    if #available(macOS 10.14, *) {
      self.channels.forEach({$0.sendEvent(key: "on_change_accent_color", payload: "\(NSColor.controlAccentColor.hexString)")})
    }
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    let project = FlutterDartProject.init()
    self.controller = CustomWindow.init(project: project);
    (self.controller as! CustomWindow).setKey(key: "statusbar");
    self.channels.append(MessageChannel.init(controller: controller))
    self.channels.append(MessageChannel.init(controller: mainFlutterWindow?.contentViewController as! FlutterViewController?, window: self.mainFlutterWindow))
    popover.contentSize = NSSize(width: 250, height: 200)
    popover.contentViewController = self.controller
    statusBar = StatusBarController.init(popover)
    
    let overlayChannel = self.channels.first {$0.controller?.key == "overlay"}
    self.windowManager = WindowManager.init(channel: overlayChannel);
    if #available(macOS 10.14, *) {
      DistributedNotificationCenter.default.addObserver(self, selector: #selector(self.onUpdateAccentColor(_:)), name: NSNotification.Name(rawValue: "AppleColorPreferencesChangedNotification"), object: nil)
    }
    RegisterGeneratedPlugins(registry: self.controller as! CustomWindow)
    super.applicationDidFinishLaunching(aNotification)
  }
}
