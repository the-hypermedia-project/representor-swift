//
//  RepresentorBuilder.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public class RepresentorBuilder {
    var transitions = Dictionary<String, Transition>()
    var representors = Dictionary<String, Representor>()
    var attributes = Dictionary<String, AnyObject>()
    var links = Dictionary<String, String>()
    var metadata = Dictionary<String, String>()

    public func addAttribute(name:String, value:AnyObject) {
        attributes[name] = value
    }

    // MARK: Representors

    public func addRepresentor(name:String, representor:Representor) {
        representors[name] = representor
    }

    public func addRepresentor(name:String, block:((builder:RepresentorBuilder) -> ())) {
        representors[name] = Representor(block)
    }

    // MARK: Transition

    public func addTransition(name:String, _ transition:Transition) {
        transitions[name] = transition
    }

    public func addTransition(name:String, uri:String) {
        let transition = Transition(uri: uri, attributes:[:], parameters:[:])
        transitions[name] = transition
    }

    public func addTransition(name:String, uri:String, builder:((TransitionBuilder) -> ())) {
        let transition = Transition(uri: uri, builder)
        transitions[name] = transition
    }

    // MARK: Links

    public func addLink(name:String, uri:String) {
        links[name] = uri
    }

    // MARK: Metadata

    public func addMetaData(key:String, value:String) {
        metadata[key] = value
    }
}

extension Representor {
    /// An extension to Representor to provide a builder interface for creating a Representor.
    public init(_ block:((builder:RepresentorBuilder) -> ())) {
        let builder = RepresentorBuilder()

        block(builder:builder)

        self.transitions = builder.transitions
        self.representors = builder.representors
        self.attributes = builder.attributes
        self.links = builder.links
        self.metadata = builder.metadata
    }
}
