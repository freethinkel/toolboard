
import Foundation
import FlutterMacOS

//{"id":185036,"position":{"x":0.0,"y":0.0},"size":{"width":400.0,"height":270.0}}

struct WindowPosition: Decodable {
  let x: Double
  let y: Double
}
struct WindowSize: Decodable {
  let width: Double
  let height: Double
}

struct WindowRect: Decodable {
    let position: WindowPosition
    let size: WindowSize
}

class MessageChannel {
  var key = "ru.freetinkel.toolboard/channel";
  var channel: FlutterMethodChannel?
  var controller: CustomWindow?
  var window: NSWindow?
  private var onWindowChange: ((CGRect) -> Void)?
    
  init(controller: FlutterViewController?, window: NSWindow? = nil) {
      self.window = window;
    self.controller = controller as! CustomWindow?;
    self.channel = FlutterMethodChannel(name: "ru.freethinkel.toolboard/mindow",
                                          binaryMessenger: self.controller!.engine.binaryMessenger);
    self.registerEvents();
  }

  func sendEvent(key: String, payload: String) {
    self.channel!.invokeMethod(key, arguments: payload)
  }

  func registerWindowChange(handler: @escaping (CGRect) -> Void) {
    self.onWindowChange = handler;
  }

  func onCurrentWindowChange(rect: CGRect) {
      self.window?.setFrame(rect, display: true);
  }

  private func registerEvents() {
    self.channel!.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "get_key") {
        result(self.controller!.key)
      }
      if (call.method == "get_screens") {
        NSLog("firstScreen: \(NSScreen.screens.first?.frame)")
        NSLog("MainScreen: \(NSScreen.main?.visibleFrame.minY) :: \(NSScreen.main?.visibleFrame.maxY)")

        result(NSScreen.screens.map {"""
        {
          "position": {
            "x": \($0.visibleFrame.origin.x),
            "y": \($0.visibleFrame.origin.y),
            "top_offset": \($0.frame.height - $0.visibleFrame.height - $0.visibleFrame.origin.y)
          },
          "size": {
            "width": \($0.visibleFrame.size.width),
            "height": \($0.visibleFrame.size.height)
          }
        }
        """})
        result([])
      }
      if (call.method == "set_current_window_frame") {
        do {
            let json = ((call.arguments as! String?) ?? "{}").data(using: .utf8)!
            let data: WindowRect = try JSONDecoder().decode(WindowRect.self, from: json);
            self.onCurrentWindowChange(rect: CGRect(origin: CGPoint(x: data.position.x, y: data.position.y), size: CGSize(width: data.size.width, height: data.size.height)));
          result("") 
        } catch {
          result("error")
        }
      }
      if (call.method == "set_window_frame") {
        do {
          let json = ((call.arguments as! String?) ?? "{}").data(using: .utf8)!
          let data: WindowRect = try JSONDecoder().decode(WindowRect.self, from: json);
          self.onWindowChange!(CGRect(origin: CGPoint(x: data.position.x, y: data.position.y), size: CGSize(width: data.size.width, height: data.size.height)))
          result("");
        } catch {
          result("error");
        }
      }
        if (call.method == "get_accent_color") {
            if #available(macOS 10.14, *) {
                NSLog("COLOR: \(NSColor.controlAccentColor.hexString)");
                result(NSColor.controlAccentColor.hexString);
            } else {
                result(nil)
            }
            
        }
    })
  }
}
