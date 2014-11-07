//
//  Representor.swift
//  Representor
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

public struct Representor {
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
