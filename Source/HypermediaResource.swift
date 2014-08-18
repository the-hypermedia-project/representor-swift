//
//  HypermediaResource.swift
//  Hypermedia Resource
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

class HypermediaResource {
    
    /// Relation type
    typealias Relation = String
    
    /// URI type
    typealias URI = NSURL

    /// State Transtion
    class Transition {
        
        /// Transition Input Property
        class InputProperty {
            
            var name: String                    /// Property name
            lazy var defaultValue = String()    /// Default value of the property
            lazy var value = String()           /// Value of the property

            init (name: String) {
                self.name = name
            }
        }
        
        var relation: Relation          /// Transition relation type
        var uri: URI                    /// URI to be excercissed during transition
        lazy var name = String()        /// Transition name
        lazy var description = String() /// Description of the transition

        init (relation: Relation, uri: URI) {
            self.relation = relation
            self.uri = uri
        }

        /// Input attributes to build the transition message-body
        func attributes() -> [InputProperty] {
            return [InputProperty]()
        }

        /// Input attributes to for URI query parameters of the transition
        func parameters() -> [InputProperty] {
            return [InputProperty]()
        }
    }

    /// Hypermedia Resource
    class Resource {
        lazy var metalinks = Dictionary<Relation, URI>()                /// Metalinks e.g. profile
        lazy var metadata = Dictionary<String, AnyObject>()             /// Arbitrary metadata
        lazy var transitions = [Transition]()                           /// Available state transitions
        lazy var attributes = Dictionary<String, AnyObject>()           /// Attributes – semantic desriptors of the resource
        lazy var resources = Array<Dictionary<Relation, Resource>>()    /// Embedded hypermedia resources
    }
}
