//
//  NSHTTPURLResponseAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 21/12/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

func jsonDeserializer(closure:([String:AnyObject] -> Representor?)) -> ((response:NSHTTPURLResponse, body:NSData) -> Representor?) {
  return { (response, body) in
    let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions(0), error: nil)

    if let object = object as? [String:AnyObject] {
      return closure(object)
    }

    return nil
  }
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
    ]

  /// An array of the supported content types in order of preference
  public static var preferredContentTypes:[String] = [
    "application/vnd.siren+json",
    "application/hal+json",
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
