//
//  RepresentorBuilderTests.swift
//  Representor
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class RepresentorBuilderTests: XCTestCase {
  func testAddAttribute() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addAttribute("name", value:"Kyle")
    }

    XCTAssertEqual(representor.attributes["name"] as String, "Kyle")
  }

  // MARK: Representors

  func testAddRepresentor() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addRepresentor("parent", representor:Representor(transitions:[:], representors:[:], attributes:[:], links:[:], metadata:[:]))
    }

    XCTAssertTrue(representor.representors["parent"] != nil)
  }

  func testAddRepresentorWithBuilder() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addRepresentor("parent") { builder in

      }
    }

    XCTAssertTrue(representor.representors["parent"] != nil)
  }

  func testAddingMultipleRepresentorsWithBuilder() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addRepresentor("parent") { builder in

      }

      builder.addRepresentor("parent") { builder in

      }
    }

    let parentRepresentors = representor.representors["parent"]!
    XCTAssertEqual(parentRepresentors.count, 2)
  }

  // MARK: Transition

  func testAddTransition() {
    let transition = HTTPTransition(uri:"/self/", attributes:[:], parameters:[:])

    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("self", transition)
    }

    XCTAssertTrue(representor.transitions["self"] != nil)
  }

  func testAddTransitionWithURI() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("self", uri:"/self/")
    }

    XCTAssertTrue(representor.transitions["self"] != nil)
  }

  func testAddTransitionWithBuilder() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("self", uri:"/self/") { builder in

      }
    }

    XCTAssertTrue(representor.transitions["self"] != nil)
  }

  // MARK: Links

  func testAddLink() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addLink("next", uri:"/next/")
    }

    XCTAssertEqual(representor.links, ["next": "/next/"])
  }

  // MARK: Metadata

  func testAddMetaData() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addMetaData("key", value:"value")
    }

    XCTAssertEqual(representor.metadata, ["key": "value"])
  }
}
