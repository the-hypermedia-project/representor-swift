//
//  GitHubAdapter.swift
//  Representor
//
//  Created by Z on 8/5/15.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class GitHubAdapterTests: XCTestCase {
  func fixture() -> [String:AnyObject] {
    return JSONFixture("poll.github", self)
  }
  
  func testConversionFromGitHub() {
    let representor = deserializeGitHub(fixture()) as Representor<HTTPTransition>
    let representorFixture = PollFixture(self)
    
//    let left = representor.representors["next"]![0].transitions["previous"]!
//    let right = representorFixture.representors["next"]![0].transitions["previous"]!
//    XCTAssertEqual(left, right)
    XCTAssertEqual(representor, representorFixture)
  }

}
