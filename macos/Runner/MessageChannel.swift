
import Foundation
import FlutterMacOS

class MessageChannel {
  var key = "ru.freetinkel.toolboard/channel";
  var channel: FlutterMethodChannel?
  var controller: CustomWindow?
    
  init(controller: FlutterViewController?) {
//    self.windowManager = windowManager;
    self.controller = controller as! CustomWindow?;
    self.channel = FlutterMethodChannel(name: "ru.freethinkel.toolboard/mindow",
                                          binaryMessenger: self.controller!.engine.binaryMessenger);
    self.registerEvents();
  }

  func sendEvent(key: String, payload: String) {
    // NSLog("msg event: key \(key) ... \(payload)")
    self.channel!.invokeMethod(key, arguments: payload)
  }

  private func registerEvents() {
    self.channel!.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "get_key") {
        result(self.controller!.key)
      }
      if (call.method == "get_screens") {
        // result(self.windowManager!.getScreens().map{"{\"width\": \($0.frame.width), \"height\": \($0.frame.height)}"})
        result([])
      }
    })
  }
}
