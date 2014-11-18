//
//  Representor.swift
//  Representor
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

public struct Representor : Equatable {
    /// The transitions available for the representor
    public let transitions:Dictionary<String, Transition>

    /// The separate representors embedded in the current representor.
    public let representors:Dictionary<String, [Representor]>

    public let links:Dictionary<String, String>

    public let metadata:Dictionary<String, String>

    /// The attributes of the representor
    public let attributes:Dictionary<String, AnyObject>

    public init(transitions:Dictionary<String, Transition>, representors:Dictionary<String, [Representor]>, attributes:Dictionary<String, AnyObject>, links:Dictionary<String, String>, metadata:Dictionary<String, String>) {
        self.transitions = transitions
        self.representors = representors
        self.attributes = attributes
        self.links = links
        self.metadata = metadata
    }
}

public func ==(lhs:Dictionary<String, [Representor]>, rhs:Dictionary<String, [Representor]>) -> Bool {
    // There is a strange Swift bug where you cannot compare a
    // dictionary which has an array of objects which conform to Equatable.
    // So to be clear, that's comparing the following:
    //
    //     Dictionary<Equatable, [Equatable]>
    //
    // If one day this problem is solved in a newer version of Swift,
    // this method can be removed and the default == implementation can be used.
    //
    // Swift ¯\_(ツ)_/¯

    if lhs.count != rhs.count {
        return false
    }

    for (key, value) in lhs {
        if let rhsValue = rhs[key] {
            if (value != rhsValue) {
                return false
            }
        } else {
            return false
        }
    }

    return true
}

public func ==(lhs:Representor, rhs:Representor) -> Bool {
    return (
        lhs.transitions == rhs.transitions &&
        lhs.representors == rhs.representors &&
        lhs.links == rhs.links &&
        lhs.metadata == rhs.metadata &&
        (lhs.attributes as NSObject) == (rhs.attributes as NSObject)
    )
}
