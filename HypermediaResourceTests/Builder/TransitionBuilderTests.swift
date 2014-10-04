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

    // MARK: Attributes

    func testAddAttribute() {
        let transition = Transition(uri:"/self/") { builder in
            builder.addAttribute("name")
        }

        XCTAssertEqual(transition.uri, "/self/")
        XCTAssertTrue(transition.attributes["name"] != nil)
    }

    func testAddAttributeWithValue() {
        let transition = Transition(uri:"/self/") { builder in
            builder.addAttribute("name", value:"Kyle Fuller", defaultValue:nil)
        }

        XCTAssertEqual(transition.uri, "/self/")
        XCTAssertTrue(transition.attributes["name"] != nil)
    }

    // MARK: Parameters

    func testAddParameter() {
        let transition = Transition(uri:"/self/") { builder in
            builder.addParameter("name")
        }

        XCTAssertEqual(transition.uri, "/self/")
        XCTAssertTrue(transition.parameters["name"] != nil)
    }

    func testAddParameterWithValue() {
        let transition = Transition(uri:"/self/") { builder in
            builder.addParameter("name", value:"Kyle Fuller", defaultValue:nil)
        }

        XCTAssertEqual(transition.uri, "/self/")
        XCTAssertTrue(transition.parameters["name"] != nil)
    }
}
