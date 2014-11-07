//
//  SirenAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Cocoa
import XCTest
import Representor

class SirenAdapterTests: XCTestCase {
    func testConversionFromSiren() {
        let representation:Dictionary<String, AnyObject> = [
            "links": [
                [ "rel": [ "next" ], "href": "/next/" ]
            ],
            "properties": [
                "name": "Kyle"
            ]
        ]

        let representor = Representor(siren:representation)

        XCTAssertEqual(representor.links, ["next": "/next/"])
        XCTAssertEqual(representor.attributes as NSObject, [ "name": "Kyle" ] as NSObject)
    }

    func testConversionToSiren() {
        let representor = Representor(transitions:[:], representors:[:], attributes:["name": "Kyle"], links:["next": "/next/"], metadata:[:])

        let representation = representor.asSiren()

        let fixture = [
            "links": [
                [ "rel": [ "next" ], "href": "/next/" ]
            ],
            "properties": [
                "name": "Kyle"
            ]
        ]

        XCTAssertEqual(representation as NSObject, fixture as NSObject)
    }
}
