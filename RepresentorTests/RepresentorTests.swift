//
//  RepresentorTests.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import Representor

class RepresentorTests: XCTestCase {
    var transition:Transition!
    var embeddedRepresentor:Representor!
    var representor:Representor!

    override func setUp() {
        super.setUp()
        transition = Transition(uri:"/self/", attributes:[:], parameters:[:])
        embeddedRepresentor = Representor(transitions:[:], representors:[:], attributes:[:], links:[:], metadata:[:])
        representor = Representor(transitions:["self": transition], representors:["embedded": [embeddedRepresentor]], attributes:["name":"Kyle"], links:["next": "/next/"], metadata:["key": "value"])
    }

    func testHasTransitions() {
        XCTAssertTrue(representor.transitions["self"] != nil)
    }

    func testHasRepresentors() {
        XCTAssertTrue(representor.representors["embedded"] != nil)
    }

    func testHasAttributes() {
        XCTAssertEqual(representor.attributes["name"] as String, "Kyle")
    }

    func testHasLinks() {
        XCTAssertEqual(representor.links, ["next": "/next/"])
    }

    func testHasMetaData() {
        XCTAssertEqual(representor.metadata, ["key": "value"])
    }

    func testEquality() {
        XCTAssertEqual(representor, Representor(transitions:["self": transition], representors:["embedded": [embeddedRepresentor]], attributes:["name":"Kyle"], links:["next": "/next/"], metadata:["key": "value"]))
        XCTAssertNotEqual(representor, Representor(transitions:[:], representors:[:], attributes:[:], links:[:], metadata:[:]))
    }
}
