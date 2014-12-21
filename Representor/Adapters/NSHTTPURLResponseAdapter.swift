//
//  NSHTTPURLResponseAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 21/12/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

enum SerializationFormat {
  case JSONHAL
  case JSONSiren

  static func fromContentType(contentType:String) -> SerializationFormat? {
    if contentType == "application/hal+json" {
      return JSONHAL
    } else if contentType == "application/vnd.siren+json" {
      return JSONSiren
    }

    return nil
  }
}

func json(data:NSData) -> [String:AnyObject]? {
  let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
  return object as? [String:AnyObject]
}

/// An extension to the Representor to add NSHTTPURLResponse conversion
extension Representor {
  public init?(response:NSHTTPURLResponse, body:NSData) {
    let contentType = response.MIMEType
    if let contentType = contentType {
      if let format = SerializationFormat.fromContentType(contentType) {
        switch format {
        case .JSONHAL:
          if let json = json(body) {
            self.init(hal:json)
            return
          }
        case .JSONSiren:
          if let json = json(body) {
            self.init(siren:json)
            return
          }
        }
      }
    }

    return nil
  }
}
