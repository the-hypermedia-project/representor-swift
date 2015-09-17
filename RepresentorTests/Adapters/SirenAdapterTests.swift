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
        "title": "Register",
        "class": ["member"],
        "href": "/register/",
        "method": "PATCH",
        "type": "application/x-www-form-urlencoded",
        "fields": [
          [ "name": "username" ],
          [ "title": "First Name", "name": "first_name", "value": "John" ],
          [ "title": "Last Name", "name": "last_name", "value": "Doe" ],
        ]
      ],
    ]
  ]

  let transition = HTTPTransition(uri: "/register/") { builder in
    builder.method = "PATCH"
    builder.suggestedContentTypes = ["application/x-www-form-urlencoded"]

    builder.addAttribute("username")
    builder.addAttribute("first_name", title: "First Name", value: "John", defaultValue: nil)
    builder.addAttribute("last_name", title: "Last Name", value: "Doe", defaultValue: nil)

    builder.addMetadata("title", value: "Register")
    builder.addMetadata("class", value: ["member"])
  }

  func fixture() -> [String:AnyObject] {
    return JSONFixture("poll.siren", forObject: self)
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
    XCTAssertEqual(representor.transitions["register"]!, [transition])
  }

  func testConversionToSirenWithAction() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("register", self.transition)
    }

    let actions = serializeSiren(representor)["actions"] as! [[String:AnyObject]]
    let action = actions[0]
    let fields = action["fields"] as! [[String:String]]
    let sortedFields = fields.sort { (lhs, rhs) in
      lhs["name"] > rhs["name"]
    }

    XCTAssertEqual(action["name"] as? String, "register")
    XCTAssertEqual(action["href"] as? String, "/register/")
    XCTAssertEqual(action["method"] as? String, "PATCH")
    XCTAssertEqual(action["type"] as? String, "application/x-www-form-urlencoded")
    XCTAssertEqual(sortedFields, [
      ["name": "username"],
      ["title": "Last Name", "name": "last_name", "value": "Doe"],
      ["title": "First Name", "name": "first_name", "value": "John"],
    ])
  }
}
