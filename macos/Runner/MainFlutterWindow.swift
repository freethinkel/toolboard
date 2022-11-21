import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = CustomWindow.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    self.isOpaque = true;
    self.styleMask = .borderless
    self.titlebarAppearsTransparent = true
    self.hasShadow = false
    self.titleVisibility = .hidden
    self.backgroundColor = .clear
    self.level = .screenSaver
    self.ignoresMouseEvents = true
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

    let channel = FlutterMethodChannel(name: "ru.freethinkel.toolboard/mindow",
                                              binaryMessenger: flutterViewController.engine.binaryMessenger)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
