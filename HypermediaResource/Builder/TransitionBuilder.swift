//
//  TransitionBuilder.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public class TransitionBuilder {

}

extension Transition {
    public init(uri:String, _ block:((builder:TransitionBuilder) -> ())) {
        let builder = TransitionBuilder()

        block(builder: builder)

        self.uri = uri
    }
}
