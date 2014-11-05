//
//  HypermediaResource.swift
//  Hypermedia Resource
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

public struct Resource {
    /// The transitions available for the resource
    public let transitions:Dictionary<String, Transition>

    /// The separate resources embedded in the current resource.
    public let resources:Dictionary<String, Resource>

    public let links:Dictionary<String, String>

    public let metadata:Dictionary<String, String>

    /// The attributes of the resource
    public let attributes:Dictionary<String, AnyObject>

    public init(transitions:Dictionary<String, Transition>, resources:Dictionary<String, Resource>, attributes:Dictionary<String, AnyObject>, links:Dictionary<String, String>, metadata:Dictionary<String, String>) {
        self.transitions = transitions
        self.resources = resources
        self.attributes = attributes
        self.links = links
        self.metadata = metadata
    }
}
