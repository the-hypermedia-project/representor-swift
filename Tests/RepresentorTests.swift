//
//  RepresentorTests.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class RepresentorTests: XCTestCase {
  var transition:HTTPTransition!
  var embeddedRepresentor:Representor<HTTPTransition>!
  var representor:Representor<HTTPTransition>!

  override func setUp() {
    super.setUp()
    transition = HTTPTransition(uri:"/self/")
    embeddedRepresentor = Representor()
    representor = Representor(transitions:["self": [transition]], representors:["embedded": [embeddedRepresentor]], attributes:["name": "Kyle" as AnyObject], metadata: ["key": "value"])
  }

  func testHasTransitions() {
    XCTAssertTrue(representor.transitions["self"] != nil)
  }

  func testHasRepresentors() {
    XCTAssertTrue(representor.representors["embedded"] != nil)
  }

  func testHasAttributes() {
    XCTAssertEqual(representor.attributes["name"] as? String, "Kyle")
  }

  func testHasMetaData() {
    XCTAssertEqual(representor.metadata, ["key": "value"])
  }

  func testEquality() {
    XCTAssertEqual(representor, Representor(transitions:["self": [transition]], representors:["embedded": [embeddedRepresentor]], attributes:["name": "Kyle" as AnyObject], metadata:["key": "value"]))
    XCTAssertNotEqual(representor, Representor())
  }

  func testHashValue() {
    let representor1 = Representor<HTTPTransition>()
    let representor2 = Representor<HTTPTransition>()
    XCTAssertEqual(representor1.hashValue, representor2.hashValue)
  }
}
