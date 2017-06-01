//
//  HTTPDeserialization.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

func jsonDeserializer(_ closure:@escaping (([String:AnyObject]) -> Representor<HTTPTransition>?)) -> ((_ response:HTTPURLResponse, _ body:Data) -> Representor<HTTPTransition>?) {
  return { (response, body) in
    let object: AnyObject? = try? JSONSerialization.jsonObject(with: body, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject

    if let object = object as? [String:AnyObject] {
      return closure(object)
    }

    return nil
  }
}

public struct HTTPDeserialization {
  public typealias Deserializer = (_ response:HTTPURLResponse, _ body:Data) -> (Representor<HTTPTransition>?)

  /// A dictionary storing the registered HTTP deserializer's and their corresponding content type.
  public static var deserializers: [String: Deserializer] = [
    "application/hal+json": jsonDeserializer { payload in
      return deserializeHAL(payload)
    },

    "application/vnd.siren+json": jsonDeserializer { payload in
      return deserializeSiren(payload)
    },
  ]

  /// An array of the supported content types in order of preference
  public static var preferredContentTypes:[String] = [
    "application/vnd.siren+json",
    "application/hal+json",
  ]

  /** Deserialize an NSHTTPURLResponse and body into a Representor.
  Uses the deserializers defined in HTTPDeserializers.
  - parameter response: The response to deserialize
  - parameter body: The HTTP Body
  :return: representor
  */
  public static func deserialize(_ response:HTTPURLResponse, body:Data) -> Representor<HTTPTransition>? {
    if let contentType = response.mimeType {
      if let deserializer = HTTPDeserialization.deserializers[contentType] {
        return deserializer(response, body)
      }
    }

    return nil
  }
}
