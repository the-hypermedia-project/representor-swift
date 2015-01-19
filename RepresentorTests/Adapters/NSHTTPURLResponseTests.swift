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

  func createResponse(contentType:String, data:NSData) -> (NSHTTPURLResponse, NSData) {
    let url = NSURL(string: "http://test.com/")!
    let headers = ["Content-Type": contentType]
    let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: "1.1", headerFields: headers)!
    return (response, data)
  }

  func createResponse(contentType:String, fixtureNamed:String) -> (NSHTTPURLResponse, NSData) {
    return createResponse(contentType, data: fixture(fixtureNamed, self))
  }

  func JSONHALFixture() -> (NSHTTPURLResponse, NSData) {
    return createResponse("application/hal+json", fixtureNamed: "poll.hal")
  }

  func JSONSirenFixture() -> (NSHTTPURLResponse, NSData) {
    return createResponse("application/vnd.siren+json", fixtureNamed: "poll.siren")
  }

  func testPreferredContentTypes() {
    let contentTypes = Representor.preferredContentTypes

    XCTAssertEqual(contentTypes, ["application/vnd.siren+json", "application/hal+json"])
  }

  func testDeserializationWithUnknownType() {
    let (response, data) = createResponse("application/unknown", data:NSData())
    let representor = Representor.deserialize(response, body: data)

    XCTAssertTrue(representor == nil)
  }

  func testDeserializationWithHALJSON() {
    let (response, body) = JSONHALFixture()
    let representor = Representor.deserialize(response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor!, representorFixture)
  }

  func testDeserializationWithSirenJSON() {
    let (response, body) = JSONSirenFixture()
    let representor = Representor.deserialize(response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor!, representorFixture)
  }

  func testCustomDeserializer() {
    let representor = Representor { builder in
      builder.addAttribute("custom", value: true)
    }

    Representor.HTTPDeserializers["application/custom"] = { (response:NSHTTPURLResponse, data:NSData) in
      return representor
    }

    let (response, body) = createResponse("application/custom", fixtureNamed: "poll.siren")
    let deserializedRepresentor = Representor.deserialize(response, body: body)

    XCTAssertEqual(deserializedRepresentor!, representor)
  }
}
