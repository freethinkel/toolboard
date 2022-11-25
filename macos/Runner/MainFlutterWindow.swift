import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
  override func awakeFromNib() {
    let flutterViewController = CustomWindow.init();
    flutterViewController.setKey(key: "overlay")
    self.contentViewController = flutterViewController
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
    let frame = NSRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    self.setFrame(frame, display: true)
    
    self.isOpaque = true;
    self.styleMask = .borderless
    self.titlebarAppearsTransparent = true
    self.hasShadow = false
    self.titleVisibility = .hidden
    self.backgroundColor = .clear
    self.level = .screenSaver
    self.ignoresMouseEvents = true
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
