//
//  Transition.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public struct InputProperty {
    public let defaultValue:AnyObject?
    public let value:AnyObject?

    // TODO: Define validators

    public init(value:AnyObject?, defaultValue:AnyObject?) {
        self.value = value
        self.defaultValue = defaultValue
    }
}

public typealias InputProperties = Dictionary<String, InputProperty>

/** Transition instances encapsulate information about interacting with links and forms. */
public struct Transition {
    public let uri:String

    public let attributes:InputProperties
    public let parameters:InputProperties

    public init(uri:String, attributes:InputProperties, parameters:InputProperties) {
        self.uri = uri
        self.attributes = attributes
        self.parameters = parameters
    }
}
