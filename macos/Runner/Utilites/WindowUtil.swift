//
//  WindowUtil.swift
//  Rectangle
//
//  Copyright © 2022 Ryan Hanson. All rights reserved.
//
import Foundation
import Cocoa

class WindowUtil {
    static func getWindowList(_ ids: [CGWindowID]? = nil) -> [WindowInfo] {
        var infos = [WindowInfo]()
        var array: CFArray?
        if let ids = ids {
            let ptr = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: ids.count)
            for i in 0..<ids.count {
                ptr[i] = UnsafeRawPointer(bitPattern: UInt(ids[i]))
            }
            let ids = CFArrayCreate(kCFAllocatorDefault, ptr, ids.count, nil)
            array = CGWindowListCreateDescriptionFromArray(ids)
        } else {
            array = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
        }
        if let array = array {
            let count = array.getCount()
            for i in 0..<count {
                let dictionary = array.getValue(i) as CFDictionary
                let id = dictionary.getValue(kCGWindowNumber) as CFNumber
                let layer = dictionary.getValue(kCGWindowLayer) as CFNumber
                let frame = (dictionary.getValue(kCGWindowBounds) as CFDictionary).toRect()
                let pid = dictionary.getValue(kCGWindowOwnerPID) as CFNumber
                if let frame = frame {
                    let info = WindowInfo(id: id as! CGWindowID, layer: layer as! Int, frame: frame, pid: pid as! pid_t)
                    infos.append(info)
                }
            }
        }
    
        return infos
    }
}

struct WindowInfo {
    let id: CGWindowID
    let layer: Int
    let frame: CGRect
    let pid: pid_t
    var bundleIdentifier: String? { NSRunningApplication(processIdentifier: pid)?.bundleIdentifier }
}
