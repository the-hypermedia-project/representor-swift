//
//  HTTPTransitionTests.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor


class InputPropertyTests : XCTestCase {
  var property: InputProperty!

  override func setUp() {
    super.setUp()
    property = InputProperty(value: "Kyle Fuller", defaultValue: nil)
  }

  func testHasValue() {
    XCTAssertEqual(property.value as? String, "Kyle Fuller")
  }

  func testHasDefaultValue() {
    XCTAssertTrue(property.defaultValue == nil)
  }

  func testEquality() {
    XCTAssertEqual(property, InputProperty(value: "Kyle Fuller", defaultValue: nil))
    XCTAssertNotEqual(property, InputProperty(value: "Kyle Fuller", defaultValue: "Name"))
  }
}


class HTTPTransitionTests : XCTestCase {
  var transition:HTTPTransition!

  override func setUp() {
    super.setUp()
    transition = HTTPTransition(uri:"/self/")
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

  func testHasMethod() {
    XCTAssertEqual(transition.method, "GET")
  }

  func testHasContentType() {
    XCTAssertEqual(transition.suggestedContentTypes, [])
  }

  func testEquality() {
    XCTAssertEqual(transition, HTTPTransition(uri:"/self/"))
    XCTAssertNotEqual(transition, HTTPTransition(uri:"/next/"))
  }

  func testHashValue() {
    let transition1 = HTTPTransition(uri:"/self/")
    let transition2 = HTTPTransition(uri:"/self/")
    XCTAssertEqual(transition1.hashValue, transition2.hashValue)
  }

  // MARK: Idempotency

  func testGETMethodIsIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "GET"

    XCTAssertTrue(transition.isIdempotent)
  }

  func testOPTIONSMethodIsIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "OPTIONS"

    XCTAssertTrue(transition.isIdempotent)
  }

  func testHEADMethodIsIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "HEAD"

    XCTAssertTrue(transition.isIdempotent)
  }

  func testPUTMethodIsIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "PUT"

    XCTAssertTrue(transition.isIdempotent)
  }

  func testDELETEMethodIsIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "DELETE"

    XCTAssertTrue(transition.isIdempotent)
  }

  func testPOSTMethodIsNotIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "POST"

    XCTAssertFalse(transition.isIdempotent)
  }

  func testPATCHMethodIsNotIdempotent() {
    var transition = HTTPTransition(uri: "/")
    transition.method = "PATCH"

    XCTAssertFalse(transition.isIdempotent)
  }
}
