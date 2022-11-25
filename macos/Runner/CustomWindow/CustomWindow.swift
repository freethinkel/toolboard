import Foundation
import FlutterMacOS

public class CustomWindow: FlutterViewController, NSWindowDelegate {
    var key: String = "__none__"

    open func setKey(key: String) {
      self.key = key;
    }

    open override func viewWillAppear() {
        let window = view.window
        window!.delegate = self

        super.viewWillAppear()
    }
}

