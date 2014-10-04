//
//  ResourceBuilderTests.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import HypermediaResource

class ResourceBuilderTests: XCTestCase {
    func testAddAttribute() {
        let resource = Resource { builder in
            builder.addAttribute("name", value:"Kyle")
        }

        XCTAssertEqual(resource.attributes["name"] as String, "Kyle")
    }

    // MARK: Resources

    func testAddResource() {
        let resource = Resource { builder in
            builder.addResource("parent", resource:Resource(transitions:[:], resources:[:], attributes:[:]))
        }

        XCTAssertTrue(resource.resources["parent"] != nil)
    }

    func testAddResourceWithBuilder() {
        let resource = Resource { builder in
            builder.addResource("parent") { builder in

            }
        }

        XCTAssertTrue(resource.resources["parent"] != nil)
    }

    // MARK: Transition

    func testAddTransition() {
        let transition = Transition(uri:"/self/")

        let resource = Resource { builder in
            builder.addTransition("self", transition)
        }

        XCTAssertEqual(resource.transitions, ["self": transition])
    }

    func testAddTransitionWithURI() {
        let resource = Resource { builder in
            builder.addTransition("self", uri:"/self/")
        }

        XCTAssertEqual(resource.transitions, ["self": Transition(uri:"/self/")])
    }

    func testAddTransitionWithBuilder() {
        let resource = Resource { builder in
            builder.addTransition("self", uri:"/self/") { builder in

            }
        }

        XCTAssertEqual(resource.transitions, ["self": Transition(uri:"/self/")])
    }
}
