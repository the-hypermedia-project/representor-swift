//
//  RepresentorBuilderTests.swift
//  Representor
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import Representor

class RepresentorBuilderTests: XCTestCase {
    func testAddAttribute() {
        let representor = Representor { builder in
            builder.addAttribute("name", value:"Kyle")
        }

        XCTAssertEqual(representor.attributes["name"] as String, "Kyle")
    }

    // MARK: Representors

    func testAddRepresentor() {
        let representor = Representor { builder in
            builder.addRepresentor("parent", representor:Representor(transitions:[:], representors:[:], attributes:[:], links:[:], metadata:[:]))
        }

        XCTAssertTrue(representor.representors["parent"] != nil)
    }

    func testAddRepresentorWithBuilder() {
        let representor = Representor { builder in
            builder.addRepresentor("parent") { builder in

            }
        }

        XCTAssertTrue(representor.representors["parent"] != nil)
    }

    // MARK: Transition

    func testAddTransition() {
        let transition = Transition(uri:"/self/", attributes:[:], parameters:[:])

        let representor = Representor { builder in
            builder.addTransition("self", transition)
        }

        XCTAssertTrue(representor.transitions["self"] != nil)
    }

    func testAddTransitionWithURI() {
        let representor = Representor { builder in
            builder.addTransition("self", uri:"/self/")
        }

        XCTAssertTrue(representor.transitions["self"] != nil)
    }

    func testAddTransitionWithBuilder() {
        let representor = Representor { builder in
            builder.addTransition("self", uri:"/self/") { builder in

            }
        }

        XCTAssertTrue(representor.transitions["self"] != nil)
    }

    // MARK: Links

    func testAddLink() {
        let representor = Representor { builder in
            builder.addLink("next", uri:"/next/")
        }

        XCTAssertEqual(representor.links, ["next": "/next/"])
    }

    // MARK: Metadata

    func testAddMetaData() {
        let representor = Representor { builder in
            builder.addMetaData("key", value:"value")
        }

        XCTAssertEqual(representor.metadata, ["key": "value"])
    }
}
