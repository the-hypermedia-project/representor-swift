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
    func testConversionFromHAL() {
        let representation:Dictionary<String, AnyObject> = [
            "_links": [
                "self": [ "href": "/orders" ]
            ],
            "_embedded": [
                "order": [
                    [
                        "_links": [
                            "next": [ "href": "next/" ],
                        ],
                    ],
                    [
                        "_links": [
                            "next": [ "href": "next/" ],
                        ],
                    ],
                ],
                "single": [
                    "_links": [
                        "next": [ "href": "next/" ],
                    ],
                ]
            ],
            "name": "Kyle",
        ]

        let representor = Representor(hal: representation)

        XCTAssertEqual(representor.links, ["self": "/orders"])
        XCTAssertEqual(representor.attributes as Dictionary<String, String>, ["name": "Kyle"])

        XCTAssertEqual(representor.representors.count, 2)
        let orderRepresentor = representor.representors["order"]!
        XCTAssertEqual(orderRepresentor.count, 2)
        XCTAssertEqual(orderRepresentor[0].links, ["next": "next/"])
    }

    func testConversionToHAL() {
        let transition = Transition(uri:"/self/", attributes:[:], parameters:[:])
        let embeddedRepresentor = Representor(transitions:[:], representors:[:], attributes:[:], links:[:], metadata:[:])
        let representor = Representor(transitions:[:], representors:["embedded": [embeddedRepresentor]], attributes:["name":"Kyle"], links:["next": "/next/"], metadata:[:])

        let representation = representor.asHAL()

        XCTAssertEqual(representation.keys.array, ["_links", "_embedded", "name"])

        XCTAssertEqual(representation["name"] as String, "Kyle")
        XCTAssertEqual(representation["_links"] as Dictionary<String, Dictionary<String, String>>, ["next": ["href":"/next/"]])

        let embedded = representation["_embedded"]! as Dictionary<String, AnyObject>
        XCTAssertEqual(embedded.keys.array, ["embedded"])
    }
}
