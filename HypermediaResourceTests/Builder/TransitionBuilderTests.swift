//
//  TransitionBuilderTests.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import HypermediaResource

class TransitionBuilderTests: XCTestCase {
    func testTransitionBuildler() {
        let transition = Transition(uri:"/self/") { builder in

        }

        XCTAssertEqual(transition.uri, "/self/")
    }
}
