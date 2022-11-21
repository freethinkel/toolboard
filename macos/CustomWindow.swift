import Foundation
import FlutterMacOS

public class CustomWindow: FlutterViewController, NSWindowDelegate {
    var key: String = "custom"

    open override func viewWillAppear() {
        let window = view.window
        window!.delegate = self

        super.viewWillAppear()
    }
}

