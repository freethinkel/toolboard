import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
  override func awakeFromNib() {
    let flutterViewController = CustomWindow.init();
    flutterViewController.setKey(key: "overlay")
    self.contentViewController = flutterViewController
    let visibleFrame = NSScreen.main!.visibleFrame;
    self.setFrame(visibleFrame, display: true, animate: true)
    
    self.isOpaque = true;
    self.styleMask = .fullSizeContentView
    
    self.titlebarAppearsTransparent = true
    self.hasShadow = false
    self.titleVisibility = .hidden
    self.backgroundColor = .clear
    self.level = .floating
    self.ignoresMouseEvents = true
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
