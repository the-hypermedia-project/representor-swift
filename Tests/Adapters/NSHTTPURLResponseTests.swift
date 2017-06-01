//
//  NSHTTPURLResponseAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 21/12/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class NSHTTPURLResponseAdapterTests: XCTestCase {

  func createResponse(_ contentType:String, data:Data) -> (HTTPURLResponse, Data) {
    let url = URL(string: "http://test.com/")!
    let headers = ["Content-Type": contentType]
    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: headers)!
    return (response, data)
  }

  func createResponse(_ contentType:String, fixtureNamed:String) -> (HTTPURLResponse, Data) {
    return createResponse(contentType, data: fixture(fixtureNamed, forObject: self))
  }

  func JSONHALFixture() -> (HTTPURLResponse, Data) {
    return createResponse("application/hal+json", fixtureNamed: "poll.hal")
  }

  func JSONSirenFixture() -> (HTTPURLResponse, Data) {
    return createResponse("application/vnd.siren+json", fixtureNamed: "poll.siren")
  }

  func testPreferredContentTypes() {
    let contentTypes = HTTPDeserialization.preferredContentTypes

    XCTAssertEqual(contentTypes, ["application/vnd.siren+json", "application/hal+json"])
  }

  func testDeserializationWithUnknownType() {
    let (response, data) = createResponse("application/unknown", data:Data())
    let representor = HTTPDeserialization.deserialize(response, body: data)

    XCTAssertTrue(representor == nil)
  }

  func testDeserializationWithHALJSON() {
    let (response, body) = JSONHALFixture()
    let representor = HTTPDeserialization.deserialize(response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func testDeserializationWithSirenJSON() {
    let (response, body) = JSONSirenFixture()
    let representor = HTTPDeserialization.deserialize(response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor!, representorFixture)
  }

  func testCustomDeserializer() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addAttribute("custom", value: true as AnyObject)
    }

    HTTPDeserialization.deserializers["application/custom"] = { (response:HTTPURLResponse, data:Data) in
      return representor
    }

    let (response, body) = createResponse("application/custom", fixtureNamed: "poll.siren")
    let deserializedRepresentor = HTTPDeserialization.deserialize(response, body: body)

    XCTAssertEqual(deserializedRepresentor!, representor)
  }
}
