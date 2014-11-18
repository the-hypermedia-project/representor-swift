//
//  TransitionTests.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import Representor


class InputPropertyTests : XCTestCase {
    var property:InputProperty<AnyObject>!

    override func setUp() {
        super.setUp()
        property = InputProperty<AnyObject>(value:"Kyle Fuller", defaultValue:nil)
    }

    func testHasValue() {
        XCTAssertEqual(property.value as String, "Kyle Fuller")
    }

    func testHasDefaultValue() {
        XCTAssertTrue(property.defaultValue == nil)
    }

    func testEquality() {
        XCTAssertEqual(property, InputProperty<AnyObject>(value:"Kyle Fuller", defaultValue:nil))
        XCTAssertNotEqual(property, InputProperty<AnyObject>(value:"Kyle Fuller", defaultValue:"Name"))
    }
}


class TransitionTests : XCTestCase {
    var transition:Transition!

    override func setUp() {
        super.setUp()
        transition = Transition(uri:"/self/", attributes:[:], parameters:[:])
    }

    func testHasURI() {
        XCTAssertEqual(transition.uri, "/self/")
    }

    func testHasAttributes() {
        XCTAssertEqual(transition.attributes.count, 0)
    }

    func testHasParameters() {
        XCTAssertEqual(transition.parameters.count, 0)
    }

    func testEquality() {
        XCTAssertEqual(transition, Transition(uri:"/self/", attributes:[:], parameters:[:]))
        XCTAssertNotEqual(transition, Transition(uri:"/next/", attributes:[:], parameters:[:]))
    }
}
