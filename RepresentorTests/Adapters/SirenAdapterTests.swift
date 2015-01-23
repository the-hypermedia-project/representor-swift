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
  let representation = ["actions":
    [
      [
        "name": "register",
        "href": "/register/",
        "method": "PATCH",
        "type": "application/x-www-form-urlencoded",
        "fields": [
          [ "name": "username" ],
          [ "name": "first_name", "value": "John" ],
          [ "name": "last_name", "value": "Doe" ],
        ]
      ],
    ]
  ]

  let transition = HTTPTransition(uri: "/register/") { builder in
    builder.method = "PATCH"
    builder.contentType = "application/x-www-form-urlencoded"

    builder.addAttribute("username")
    builder.addAttribute("first_name", value: "John", defaultValue: nil)
    builder.addAttribute("last_name", value: "Doe", defaultValue: nil)
  }

  func fixture() -> Dictionary<String, AnyObject> {
    return JSONFixture("poll.siren", self)
  }

  func testConversionFromSiren() {
    let representor = deserializeSiren(fixture())
    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func testConversionToSiren() {
    let representor = PollFixture(self)
    let representation = serializeSiren(representor)

    XCTAssertEqual(representation as NSObject, fixture() as NSObject)
  }

  func testConversionFromSirenWithAction() {
    let representor = deserializeSiren(representation)
    XCTAssertEqual(representor.transitions["register"]!, transition)
  }

  func testConversionToSirenWithAction() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("register", self.transition)
    }

    let actions = serializeSiren(representor)["actions"] as [[String:AnyObject]]
    let action = actions[0]
    let fields = action["fields"] as [[String:String]]
    let sortedFields = fields.sorted { (lhs, rhs) in
      lhs["name"] > rhs["name"]
    }

    XCTAssertEqual(action["name"] as String, "register")
    XCTAssertEqual(action["href"] as String, "/register/")
    XCTAssertEqual(action["method"] as String, "PATCH")
    XCTAssertEqual(action["type"] as String, "application/x-www-form-urlencoded")
    XCTAssertEqual(sortedFields, [
      ["name": "username"],
      ["name": "last_name", "value": "Doe"],
      ["name": "first_name", "value": "John"],
    ])
  }
}
