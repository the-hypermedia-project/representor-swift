//
//  NSHTTPURLResponseAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 21/12/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import WebLinking

func jsonDeserializer(closure:([String:AnyObject] -> Representor?)) -> ((response:NSHTTPURLResponse, body:NSData) -> Representor?) {
  return { (response, body) in
    let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions(0), error: nil)

    if let object = object as? [String:AnyObject] {
      return closure(object)
    }

    return nil
  }
}

func jsonRequestDeserializer(response:NSHTTPURLResponse, body:NSData) -> Representor? {
  let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions(0), error: nil)

  var links = [String:String]()
  for link in response.links {
    if let relation = link.relationType {
      links[relation] = link.uri
    }
  }

  if let attributes = object as? [String:AnyObject] {
    return Representor(transitions: [:], representors: [:], attributes: attributes, links: links, metadata: [:])
  } else if let items = object as? [AnyObject] {
    return Representor(transitions: [:], representors: [:], attributes: ["items": items], links: links, metadata: [:])
  }

  return nil
}

/// An extension to the Representor to add NSHTTPURLResponse deserialization
extension Representor {
  public typealias HTTPDeserializer = (response:NSHTTPURLResponse, body:NSData) -> (Representor?)

  /// A dictionary storing the registered HTTP deserializer's and their corresponding content type.
  public static var HTTPDeserializers:[String:HTTPDeserializer] = [
      "application/hal+json": jsonDeserializer { payload in
        return Representor(hal: payload)
      },

      "application/vnd.siren+json": jsonDeserializer { payload in
        return Representor(siren: payload)
      },

      "application/json": jsonRequestDeserializer,
    ]

  /// An array of the supported content types in order of preference
  public static var preferredContentTypes:[String] = [
    "application/vnd.siren+json",
    "application/hal+json",
    "application/json",
  ]

  /** Deserialize an NSHTTPURLResponse and body into a Representor.
  Uses the deserializers defined in HTTPDeserializers.
  :param: response The response to deserialize
  :param: body The HTTP Body
  :return: representor
  */
  public static func deserialize(response:NSHTTPURLResponse, body:NSData) -> Representor? {
    if let contentType = response.MIMEType {
      if let deserializer = Representor.HTTPDeserializers[contentType] {
        return deserializer(response: response, body: body)
      }
    }

    return nil
  }
}
