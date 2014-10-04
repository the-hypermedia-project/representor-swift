//
//  ResourceBuilder.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public class ResourceBuilder {
    var transitions = Dictionary<String, Transition>()
    var resources = Dictionary<String, Resource>()
    var attributes = Dictionary<String, AnyObject>()

    public func addAttribute(name:String, value:AnyObject) {
        attributes[name] = value
    }

    // MARK: Resources

    public func addResource(name:String, resource:Resource) {
        resources[name] = resource
    }

    public func addResource(name:String, block:((builder:ResourceBuilder) -> ())) {
        let resource = Resource(block)
        resources[name] = resource
    }

    // MARK: Transition

    public func addTransition(name:String, _ transition:Transition) {
        transitions[name] = transition
    }

    public func addTransition(name:String, uri:String) {
        let transition = Transition(uri: uri)
        transitions[name] = transition
    }

    public func addTransition(name:String, uri:String, builder:((TransitionBuilder) -> ())) {
        let transition = Transition(uri: uri, builder)
        transitions[name] = transition
    }
}

extension Resource {
    public init(_ block:((builder:ResourceBuilder) -> ())) {
        let builder = ResourceBuilder()

        block(builder:builder)

        self.transitions = builder.transitions
        self.resources = builder.resources
        self.attributes = builder.attributes
    }
}
