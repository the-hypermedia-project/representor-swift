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

  func testInitializationWithUnknownType() {
    let (response, data) = createResponse("application/json", data:NSData())
    let representor = Representor(response: response, body: data)

    XCTAssertTrue(representor == nil)
  }

  func testInitializationWithHALJSON() {
    let (response, body) = JSONHALFixture()
    let representor = Representor(response: response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor!, representorFixture)
  }

  func testInitializationWithSirenJSON() {
    let (response, body) = JSONSirenFixture()
    let representor = Representor(response: response, body: body)

    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor!, representorFixture)
  }
}
