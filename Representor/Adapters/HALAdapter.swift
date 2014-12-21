//
//  HALAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import URITemplate

func parseHALLinks(halLinks:Dictionary<String, Dictionary<String, AnyObject>>) -> Dictionary<String, URITemplate> {
  var links = Dictionary<String, URITemplate>()

  for (link, options) in halLinks {
    if let href = options["href"] as? String {
      links[link] = URITemplate(template:href)
    }
  }

  return links
}


func parseEmbeddedHALs(embeddedHALs:Dictionary<String, AnyObject>) -> Dictionary<String, [Representor]> {
  var representors = Dictionary<String, [Representor]>()

  func parseEmbedded(embedded:Dictionary<String, AnyObject>) -> Representor {
    return Representor(hal:embedded)
  }

  for (name, embedded) in embeddedHALs {
    if let embedded = embedded as? [Dictionary<String, AnyObject>] {
      representors[name] = embedded.map {
        Representor(hal: $0)
      }
    } else if let embedded = embedded as? Dictionary<String, AnyObject> {
      representors[name] = [Representor(hal:embedded)]
    }
  }

  return representors
}

/// An extension to the Representor to add HAL support
extension Representor {
  public init(hal:Dictionary<String, AnyObject>) {
    var hal = hal

    var links = Dictionary<String, URITemplate>()
    if let halLinks = hal.removeValueForKey("_links") as? Dictionary<String, Dictionary<String, AnyObject>> {
      links = parseHALLinks(halLinks)
    }

    var representors = Dictionary<String, [Representor]>()
    if let embedded = hal.removeValueForKey("_embedded") as? Dictionary<String, AnyObject> {
      representors = parseEmbeddedHALs(embedded)
    }

    self.transitions = [:]
    self.representors = representors
    self.attributes = hal
    self.links = links
    self.metadata = [:]
  }

  public func asHAL() -> Dictionary<String, AnyObject> {
    var representation = attributes

    if links.count > 0 {
      var links = Dictionary<String, Dictionary<String, AnyObject>>()

      for (relation, uri) in self.links {
        if uri.variables.count > 0 {
          links[relation] = [
            "href": uri.template,
            "templated": true,
          ]
        } else {
          links[relation] = ["href": uri.template]
        }
      }

      representation["_links"] = links
    }

    if representors.count > 0 {
      var embeddedHALs = Dictionary<String, [Dictionary<String, AnyObject>]>()

      for (name, representorSet) in representors {
        embeddedHALs[name] = representorSet.map { representor in
          representor.asHAL()
        }
      }

      representation["_embedded"] = embeddedHALs
    }

    return representation
  }
}
