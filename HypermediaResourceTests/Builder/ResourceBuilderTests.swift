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
            builder.addResource("parent", resource:Resource(transitions:[:], resources:[:], attributes:[:], links:[:]))
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
        let transition = Transition(uri:"/self/", attributes:[:], parameters:[:])

        let resource = Resource { builder in
            builder.addTransition("self", transition)
        }

        XCTAssertTrue(resource.transitions["self"] != nil)
    }

    func testAddTransitionWithURI() {
        let resource = Resource { builder in
            builder.addTransition("self", uri:"/self/")
        }

        XCTAssertTrue(resource.transitions["self"] != nil)
    }

    func testAddTransitionWithBuilder() {
        let resource = Resource { builder in
            builder.addTransition("self", uri:"/self/") { builder in

            }
        }

        XCTAssertTrue(resource.transitions["self"] != nil)
    }

    // MARK: Links

    func testAddLink() {
        let resource = Resource { builder in
            builder.addLink("next", uri:"/next/")
        }

        XCTAssertEqual(resource.links, ["next": "/next/"])
    }
}
