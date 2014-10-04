//
//  TransitionTests.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import HypermediaResource

class TransitionTests : XCTestCase {
    var transition:Transition!

    override func setUp() {
        super.setUp()
        transition = Transition(uri:"/self/")
    }

    func testHasURI() {
        XCTAssertEqual(transition.uri, "/self/")
    }

    func testTransitionEquality() {
        XCTAssertEqual(transition, Transition(uri:"/self/"))
    }
}
