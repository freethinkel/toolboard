import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()
  var controller: FlutterViewController?;
  var channels: [MessageChannel] = []
//  var windowManager: WindowManager?

  override init() {
    super.init();
//    self.windowManager = WindowManager.init(onEvent: self.onWindowChangeEvent);
    popover.behavior = NSPopover.Behavior.transient
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  func onWindowChangeEvent(key: String, event: String) {
    let overlayChannel = self.channels.first {$0.controller?.key == "overlay"}
    overlayChannel?.sendEvent(key: key, payload: event)
  }
  func jsonFromWindow(win: AccessibilityElement?) -> String {
    if (win != nil) {
      return """
      {
        "id": \(win!.windowId ?? 0),
        "frame": {
          "height": \(win!.frame.height),
          "width": \(win!.frame.width)
        }
      }
      """
    }
    return "null"
  }

  var windowElement: AccessibilityElement?;
  var windowId: CGWindowID?
  var windowMoving: Bool = false
  var lastWindowIdAttempt: TimeInterval?
  var windowIdAttempt: Int = 0
  var initialWindowRect: CGRect?
    
    
  func onUpdate(event: NSEvent) {
    switch event.type {
      case .leftMouseDown:
        windowElement = AccessibilityElement.getWindowElementUnderCursor()
        windowId = windowElement?.getWindowId()
        initialWindowRect = windowElement?.frame
        self.onWindowChangeEvent(key: "on_mouse_down", event: """
        {
          "x": \(event.cgEvent?.location.x ?? 0.0),
          "y": \(event.cgEvent?.location.y ?? 0.0),
          "window": \(self.jsonFromWindow(win: windowElement))
        }
        """);
      case .leftMouseUp:
        self.onWindowChangeEvent(key: "on_mouse_up", event: """
        {
          "x": \(event.cgEvent?.location.x ?? 0.0),
          "y": \(event.cgEvent?.location.y ?? 0.0),
          "window": \(self.jsonFromWindow(win: windowElement))
        }
        """);

        windowElement = nil
        windowId = nil
        windowMoving = false
        initialWindowRect = nil
        windowIdAttempt = 0
        lastWindowIdAttempt = nil
      case .leftMouseDragged:
        if windowId == nil, windowIdAttempt < 20 {
          if let lastWindowIdAttempt = lastWindowIdAttempt {
            if event.timestamp - lastWindowIdAttempt < 0.1 {
              return
            }
          }
          if windowElement == nil {
            windowElement = AccessibilityElement.getWindowElementUnderCursor()
          }
          windowId = windowElement?.getWindowId()
          initialWindowRect = windowElement?.frame
          windowIdAttempt += 1
          lastWindowIdAttempt = event.timestamp
        }
        if !windowMoving {
          guard let currentRect = windowElement?.frame,
            let windowId = windowId
          else { return }
          if currentRect.size == initialWindowRect?.size {
            if currentRect.origin != initialWindowRect?.origin {
              windowMoving = true
              // unsnapRestore(windowId: windowId)
            }
          }
        } else {
          self.onWindowChangeEvent(key: "on_mouse_dragged", event: """
          {
            "x": \(event.cgEvent?.location.x ?? 0.0),
            "y": \(event.cgEvent?.location.y ?? 0.0),
            "window": \(self.jsonFromWindow(win: windowElement))
          }
          """)
        }
      default:
      return
    }
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
      
      
    let ev = PassiveEventMonitor(mask: [.leftMouseDown, .leftMouseUp, .leftMouseDragged], handler: self.onUpdate)
    ev.start()
    print("INIT LIST")
    super.applicationDidFinishLaunching(aNotification)
  }
}
