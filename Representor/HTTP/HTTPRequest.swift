//
//  HTTPRequest.swift
//  Representor
//
//  Created by Kyle Fuller on 30/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation
import Alamofire
import URITemplate

extension HTTPTransition {
  var suggestedParameterEncoding:ParameterEncoding {
    let encodingMapping = [
      "application/json": ParameterEncoding.JSON,
      "application/x-www-form-urlencoded": ParameterEncoding.URL,
      "application/x-plist": ParameterEncoding.PropertyList(.XMLFormat_v1_0, NSPropertyListWriteOptions(0)),
    ]

    for contentType in suggestedContentTypes {
      if let encoding = encodingMapping[contentType] {
        return encoding
      }
    }

    return .URL
  }
}

extension Alamofire.Manager {
  public func request(baseURL: NSURL?, transition: HTTPTransition, parameters: [String : AnyObject]? = nil, attributes: [String : AnyObject]? = nil, encoding:ParameterEncoding? = nil) -> Alamofire.Request {
    let template = URITemplate(template: transition.uri)
    let URL = NSURL(string: template.expand(parameters ?? [:]), relativeToURL: baseURL)!
    return request(Method(rawValue:transition.method)!, URL.absoluteString!, parameters: attributes, encoding: encoding ?? transition.suggestedParameterEncoding)
  }
}

extension Alamofire.Request {
  func responseRepresentor(closure:((request:NSURLRequest, response:NSURLResponse?, representor:Representor<HTTPTransition>?, error:NSError?) -> Void)) -> Self {
    return response { (request, response, data, error) -> Void in
      var representor:Representor<HTTPTransition>?

      if let response = response {
        if let data = data as? NSData {
          representor = HTTPDeserialization.deserialize(response, body:data)
        }
      }

      closure(request: request, response: response, representor: representor, error: error)
    }
  }
}

public func request(baseURL: NSURL?, transition: HTTPTransition, parameters: [String : AnyObject]? = nil, attributes: [String : AnyObject]? = nil, encoding:ParameterEncoding? = nil) -> Request {
  return Manager.sharedInstance.request(baseURL, transition: transition, parameters: parameters, attributes: attributes, encoding: encoding)
}
