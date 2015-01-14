//
//  SirenAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class SirenAdapterTests: XCTestCase {
  func fixture() -> Dictionary<String, AnyObject> {
    return JSONFixture("poll.siren", self)
  }

  func testConversionFromSiren() {
    let representor = Representor(siren:fixture())
    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func testConversionToSiren() {
    let representor = PollFixture(self)
    let representation = representor.asSiren()

    XCTAssertEqual(representation as NSObject, fixture() as NSObject)
  }

  func testConversionFromSirenWithAction() {
    let representation = ["actions":
      [
        [
          "name": "register",
          "href": "/register/",
          "fields": [
            [ "name": "username" ],
            [ "name": "first_name", "value": "John" ],
            [ "name": "last_name", "value": "Doe" ],
          ]
        ],
      ]
    ]

    let representor = Representor(siren:representation)

    let transition = Transition(uri: "/register/") { builder in
      builder.addAttribute("username")
      builder.addAttribute("first_name", value: "John", defaultValue: nil)
      builder.addAttribute("last_name", value: "Doe", defaultValue: nil)
    }

    XCTAssertEqual(representor.transitions["register"]!, transition)
  }
}
