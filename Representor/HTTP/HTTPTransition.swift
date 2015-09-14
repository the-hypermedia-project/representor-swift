//
//  HTTPTransition.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

/** An implementation of the Transition protocol for HTTP. */
public struct HTTPTransition : TransitionType {
    public typealias Builder = HTTPTransitionBuilder

    public var uri:String

    /// The HTTP Method that should be used to make the request
    public var method:String

    /// The suggested contentType that should be used to make the request
    public var suggestedContentTypes:[String]

    public var attributes:InputProperties
    public var parameters:InputProperties

    public init(uri:String, attributes:InputProperties? = nil, parameters:InputProperties? = nil) {
        self.uri = uri
        self.attributes = attributes ?? [:]
        self.parameters = parameters ?? [:]
        self.method = "GET"
        self.suggestedContentTypes = [String]()
    }

    public init(uri:String, _ block:((builder:Builder) -> ())) {
        let builder = Builder()

        block(builder: builder)

        self.uri = uri
        self.attributes = builder.attributes
        self.parameters = builder.parameters
        self.method = builder.method
        self.suggestedContentTypes = builder.suggestedContentTypes
    }

    public var hashValue:Int {
        return uri.hashValue
    }
}

public func ==(lhs:HTTPTransition, rhs:HTTPTransition) -> Bool {
    return (
        lhs.uri == rhs.uri &&
        lhs.attributes == rhs.attributes &&
        lhs.parameters == rhs.parameters &&
        lhs.method == rhs.method &&
        lhs.suggestedContentTypes == rhs.suggestedContentTypes
    )
}
