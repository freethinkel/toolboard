import Foundation
import Cocoa

public class WindowManager {
  var channel: MessageChannel;
  var monitor: EventMonitor?;


  var windowElement: AccessibilityElement?;
  var windowId: CGWindowID?
  var windowMoving: Bool = false
  var lastWindowIdAttempt: TimeInterval?
  var windowIdAttempt: Int = 0
  var initialWindowRect: CGRect?
  var prevScreen: NSScreen?

  init(channel: MessageChannel?) {
      self.channel = channel!
    self.onInit();
  }

  private func onInit() {
    self.monitor = PassiveEventMonitor(mask: [.leftMouseDown, .leftMouseUp, .leftMouseDragged], handler: self.onUpdate)
    self.channel.registerWindowChange(handler: self.setWindowRect)
  }

  func startListen() {
      self.monitor!.start();
  }

  func stopListen() {
      self.monitor!.stop();
  }
    
  func setWindowRect(rect: CGRect, id: Int?) {
    var windowElement: AccessibilityElement?;
    if (id != nil) {
        windowElement = AccessibilityElement.getWindowFromId(id: CGWindowID.init(id!))
    }
    if (windowElement == nil) {
      windowElement = AccessibilityElement.getWindowElementUnderCursor()
    }
      windowElement?.setFrame(rect)
  }

  func onWindowChangeEvent(key: String, event: String) {
    self.channel.sendEvent(key: key, payload: event)
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

  private func getCurrentScreen() -> NSScreen? {
    let mouseLocation = NSEvent.mouseLocation
    let screens = NSScreen.screens
    return screens.first { NSMouseInRect(mouseLocation, $0.frame, false) }
  }

  private func updateScreen() {
    let screen = self.getCurrentScreen()!;
    self.channel.updateScreen(screen: screen);
  }

    
  func onUpdate(event: NSEvent) {
    let screen = getCurrentScreen()

    if (screen?.visibleFrame.origin != prevScreen?.visibleFrame.origin || screen?.visibleFrame.size != prevScreen?.visibleFrame.size) {
      self.updateScreen();
    }

    prevScreen = screen;

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
          guard let currentRect = windowElement?.frame
          else { return }
          if currentRect.size == initialWindowRect?.size {
            if currentRect.origin != initialWindowRect?.origin {
              windowMoving = true
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
}
