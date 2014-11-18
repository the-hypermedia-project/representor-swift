//
//  HALAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import Representor

class HALAdapterTests: XCTestCase {
    func fixture() -> Dictionary<String, AnyObject> {
        return JSONFixture("poll.hal", self)
    }

    func testConversionFromHAL() {
        let representor = Representor(hal: fixture())
        let representorFixture = PollFixture(self)

        XCTAssertEqual(representor, representorFixture)
    }

    func testConversionToHAL() {
        let embeddedRepresentor = Representor(transitions:[:], representors:[:], attributes:["name": "Embedded"], links:[:], metadata:[:])
        let representor = Representor(transitions:[:], representors:["embedded": [embeddedRepresentor]], attributes:["name":"Kyle"], links:["next": "/next/"], metadata:[:])

        let representation = representor.asHAL()

        let fixture = [
            "_links": [
                "next": [ "href": "/next/" ],
            ],
            "_embedded": [
                "embedded": [
                    [
                        "name": "Embedded",
                    ]
                ]
            ],
            "name": "Kyle",
        ]

        XCTAssertEqual(representation as NSObject, fixture as NSObject)
    }
}
