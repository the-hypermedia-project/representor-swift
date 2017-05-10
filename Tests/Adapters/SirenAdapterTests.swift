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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
  }

  func fixture() -> [String: Any] {
    return JSONFixture("poll.siren", forObject: self)
  }

  func testConversionFromSiren() {
    let representor = deserializeSiren(fixture())
    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func xtestConversionToSiren() {
    // Skipped because the order of items in the representation may differ from our fixture

    let representor = PollFixture(self)
    let representation = serializeSiren(representor)

    XCTAssertEqual(representation as NSDictionary, fixture() as NSDictionary)
  }

  func testConversionFromSirenWithAction() {
    let representor = deserializeSiren(representation)

    XCTAssertEqual(representor.transitions["register"]?.first, transition)
  }

  func testConversionToSirenWithAction() {
    let representor = Representor<HTTPTransition> { builder in
      builder.addTransition("register", self.transition)
    }

    let actions = serializeSiren(representor)["actions"] as! [[String: AnyObject]]
    let action = actions[0]
    let fields = action["fields"] as! [[String: String]]
    let sortedFields = fields.sorted { (lhs, rhs) in
      lhs["name"] > rhs["name"]
    }

    XCTAssertEqual(action["name"] as? String, "register")
    XCTAssertEqual(action["href"] as? String, "/register/")
    XCTAssertEqual(action["method"] as? String, "PATCH")
    XCTAssertEqual(action["type"] as? String, "application/x-www-form-urlencoded")
    XCTAssertEqual(sortedFields as NSArray, [
      ["name": "username"],
      ["title": "Last Name", "name": "last_name", "value": "Doe"],
      ["title": "First Name", "name": "first_name", "value": "John"],
    ] as NSArray)
  }
}
