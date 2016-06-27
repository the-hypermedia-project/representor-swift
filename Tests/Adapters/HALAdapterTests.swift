//
//  HALAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class HALAdapterTests: XCTestCase {
  func fixture() -> [String:AnyObject] {
    return JSONFixture("poll.hal", forObject: self)
  }

  func testConversionFromHAL() {
    let representor = deserializeHAL(fixture()) as Representor<HTTPTransition>
    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func testConversionToHAL() {
    let representor = PollFixture(self)
    let representation = serializeHAL(representor)

    XCTAssertEqual(representation as NSObject, fixture() as NSObject)
  }

  func testLinkConversionFromHALWithMultipleTransitions() {
    let representation = [
      "_links": [
        "items": [
          [ "href": "/first_item" ],
          [ "href": "/second_item" ],
        ]
      ]
    ]
    let representor = deserializeHAL(representation)

    XCTAssertEqual(representor.transitions["items"]?.count, 2)
  }

  func testLinkConversionToHALWithMultipleTransitions() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("items", uri: "/first_item")
      builder.addTransition("items", uri: "/second_item")
    }
    let representation = serializeHAL(representor)

    XCTAssertEqual(representation as NSDictionary, [
      "_links": [
        "items": [
            [ "href": "/first_item" ],
            [ "href": "/second_item" ],
          ]
        ]
    ])
  }

  func testValidLinkAttributes() {
    let linkFixture = JSONFixture("link-objects.hal", forObject: self)
    let representor = deserializeHAL(linkFixture) as Representor<HTTPTransition>

    guard let findTransition = representor.transitions["find"]?.first else {
      XCTFail("Expected 'find' transition.")
      return
    }
    XCTAssertNotNil(findTransition.attributes["templated"]?.value as? Bool)
    XCTAssertNotNil(findTransition.attributes["type"]?.value as? String)
    XCTAssertNotNil(findTransition.attributes["name"]?.value as? String)
    XCTAssertNotNil(findTransition.attributes["title"]?.value as? String)
    XCTAssertNotNil(findTransition.attributes["hreflang"]?.value as? String)

    XCTAssertEqual(representor.transitions["admin"]?.count, 2)
    for adminTransition in representor.transitions["admin"]! {
      XCTAssertNotNil(adminTransition.attributes["deprecation"])
    }
  }

  func testInvalidLinkAttribute() {
    let linkFixture = JSONFixture("link-objects.hal", forObject: self)
    let representor = deserializeHAL(linkFixture) as Representor<HTTPTransition>

    guard let testTransition = representor.transitions["test"]?.first else {
      XCTFail("Expected 'test' transition.")
      return
    }
    XCTAssertNil(testTransition.attributes["invalid-attribute"])
  }
}
