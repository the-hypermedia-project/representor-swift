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
        let representor = PollFixture(self)
        let representation = representor.asHAL()

        XCTAssertEqual(representation as NSObject, fixture() as NSObject)
    }
}
