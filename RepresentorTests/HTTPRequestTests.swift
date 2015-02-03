//
//  HTTPRequestTests.swift
//  Representor
//
//  Created by Kyle Fuller on 30/01/2015.
//  Copyright (c) 2015 Apiary LTD. All rights reserved.
//

import Foundation
import XCTest
import Representor
import Alamofire

class HTTPRequestTests: XCTestCase {
  func testJoinesBaseURLToURI() {
    let baseURL = NSURL(string: "https://api.apiary.io/")
    let transition = HTTPTransition(uri: "notes")
    let req = request(baseURL, transition)
    
    XCTAssertEqual(req.request.URL.absoluteString!, "https://api.apiary.io/notes")
  }
  
  func testExpandsURITemplates() {
    let baseURL = NSURL(string: "https://api.apiary.io/")
    let transition = HTTPTransition(uri: "notes/{id}")
    let req = request(baseURL, transition, parameters:["id": "4"])
    
    XCTAssertEqual(req.request.URL.absoluteString!, "https://api.apiary.io/notes/4")
  }

  func testEncodesAttributesAsFormEncodedByDefault() {
    let baseURL = NSURL(string: "https://api.apiary.io/")
    let transition = HTTPTransition(uri: "notes/{id}")
    let req = request(baseURL, transition, attributes:["key": "value"])
    let data = req.request.HTTPBody!
    let body = NSString(data: data, encoding: NSUTF8StringEncoding)!
    let headers = req.request.allHTTPHeaderFields!

    XCTAssertEqual(headers["Content-Type"] as String, "application/x-www-form-urlencoded")
    XCTAssertEqual(body, "key=value")
  }
  
  func testEncodesAttributesAsJSONWhenSuggested() {
    let baseURL = NSURL(string: "https://api.apiary.io/")
    let transition = HTTPTransition(uri: "notes/{id}") { builder in
      builder.suggestedContentTypes = ["application/json"]
    }
    let req = request(baseURL, transition, attributes:["key": "value"])
    let data = req.request.HTTPBody!
    let body = NSString(data: data, encoding: NSUTF8StringEncoding)!
    let headers = req.request.allHTTPHeaderFields!
    
    XCTAssertEqual(headers["Content-Type"] as String, "application/json")
    XCTAssertEqual(body, "{\"key\":\"value\"}")
  }
  
  func testEncodesAttributesWithExplicitEncoding() {
    let baseURL = NSURL(string: "https://api.apiary.io/")
    let transition = HTTPTransition(uri: "notes/{id}")
    let req = request(baseURL, transition, attributes:["key": "value"], encoding:.JSON)
    let data = req.request.HTTPBody!
    let body = NSString(data: data, encoding: NSUTF8StringEncoding)!
    let headers = req.request.allHTTPHeaderFields!
    
    XCTAssertEqual(headers["Content-Type"] as String, "application/json")
    XCTAssertEqual(body, "{\"key\":\"value\"}")
  }
}
