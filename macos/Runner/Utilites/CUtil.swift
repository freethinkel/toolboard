import Foundation
import Cocoa

class CUtil {
    
    // bridge object into a pointer to pass into C function
    static func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    }
    
    // bridge pointer back into an object within C function
    static func bridge<T : AnyObject>(ptr : UnsafeMutableRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }
    
}


extension Sequence {
    func uniqueMap<T>(_ transform: (Element) -> T) -> [T] where T: Hashable {
        var set = Set<T>()
        var array = Array<T>()
        for element in self {
            let element = transform(element)
            if set.insert(element).inserted {
                array.append(element)
            }
        }
        return array
    }
}


extension CGPoint {
    var screenFlipped: CGPoint {
        .init(x: x, y: NSScreen.screens[0].frame.maxY - y)
    }
}

extension CGRect {
    var screenFlipped: CGRect {
        .init(origin: .init(x: origin.x, y: NSScreen.screens[0].frame.maxY - maxY), size: size)
    }
}
