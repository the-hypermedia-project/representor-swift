//
//  HTTPDeserialization.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

func jsonDeserializer(closure:([String:AnyObject] -> Representor<HTTPTransition>?)) -> ((response:NSHTTPURLResponse, body:NSData) -> Representor<HTTPTransition>?) {
  return { (response, body) in
    let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions(0), error: nil)

    if let object = object as? [String:AnyObject] {
      return closure(object)
    }

    return nil
  }
}

public struct HTTPDeserialization {
  public typealias Deserializer = (response:NSHTTPURLResponse, body:NSData) -> (Representor<HTTPTransition>?)

  /// A dictionary storing the registered HTTP deserializer's and their corresponding content type.
  public static var deserializers:[String:Deserializer] = [
    "application/hal+json": jsonDeserializer { payload in
      return deserializeHAL(payload)
    },

    "application/vnd.siren+json": jsonDeserializer { payload in
      return deserializeSiren(payload)
    },
    
    "application/vnd.github.v3+json": jsonDeserializer { payload in
      return deserializeGitHub(payload)
    },
    
  ]

  /// An array of the supported content types in order of preference
  public static var preferredContentTypes:[String] = [
    "application/vnd.siren+json",
    "application/hal+json",
    "application/vnd.github.v3+json"
  ]

  /** Deserialize an NSHTTPURLResponse and body into a Representor.
  Uses the deserializers defined in HTTPDeserializers.
  :param: response The response to deserialize
  :param: body The HTTP Body
  :return: representor
  */
  public static func deserialize(response:NSHTTPURLResponse, body:NSData) -> Representor<HTTPTransition>? {
    if let contentType = response.MIMEType {
      if let deserializer = HTTPDeserialization.deserializers[contentType] {
        return deserializer(response: response, body: body)
      }
      else if let githubMediaType = response.allHeaderFields["X-GitHub-Media-Type"] as? String {
        // Work around for GitHub media type
        if githubMediaType == "github.v3; format=json" {
          if let deserializer = HTTPDeserialization.deserializers["application/vnd.github.v3+json"] {
            return deserializer(response: response, body: body)
          }
        }
      }
    }
    

    return nil
  }
}
