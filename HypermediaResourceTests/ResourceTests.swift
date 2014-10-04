//
//  ResourceTests.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import HypermediaResource

class ResourceTests: XCTestCase {
    var transition:Transition!
    var embeddedResource:Resource!
    var resource:Resource!

    override func setUp() {
        super.setUp()
        transition = Transition(uri:"/self/")
        embeddedResource = Resource(transitions:[:], resources:[:], attributes:[:])
        resource = Resource(transitions:["self": transition], resources:["embedded": embeddedResource], attributes:["name":"Kyle"])
    }

    func testHasTransitions() {
        XCTAssertEqual(resource.transitions, ["self": transition])
    }

    func testHasResources() {
        XCTAssertTrue(resource.resources["embedded"] != nil)
    }

    func testHasAttributes() {
        XCTAssertEqual(resource.attributes["name"] as String, "Kyle")
    }
}
