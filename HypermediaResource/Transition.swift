//
//  Transition.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

/** Transition instances encapsulate information about interacting with links and forms. */
public struct Transition {
    public let uri:String

    public init(uri:String) {
        self.uri = uri
    }
}
