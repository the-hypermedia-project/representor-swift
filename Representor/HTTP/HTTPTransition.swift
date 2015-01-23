//
//  HTTPTransition.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

/** An implementation of the Transition protocol for HTTP. */
public struct HTTPTransition : Transition {
    public typealias Builder = HTTPTransitionBuilder

    public let uri:String

    /// The HTTP Method that should be used to make the request
    public let method:String = "POST"
    /// The suggested contentType that should be used to make the request
    public let contentType:String?

    public let attributes:InputProperties
    public let parameters:InputProperties

    public init(uri:String, attributes:InputProperties, parameters:InputProperties) {
        self.uri = uri
        self.attributes = attributes
        self.parameters = parameters
    }

    public init(uri:String, _ block:((builder:Builder) -> ())) {
        let builder = Builder()

        block(builder: builder)

        self.uri = uri
        self.attributes = builder.attributes
        self.parameters = builder.parameters
        self.method = builder.method
        self.contentType = builder.contentType
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
        lhs.contentType == rhs.contentType
    )
}
