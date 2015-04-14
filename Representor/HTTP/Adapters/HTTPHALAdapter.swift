//
//  HTTPHALAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

func parseHALLinks(halLinks:[String:[String:AnyObject]]) -> [String:String] {
  var links = [String:String]()

  for (link, options) in halLinks {
    if let href = options["href"] as? String {
      links[link] = href
    }
  }

  return links
}


func parseEmbeddedHALs<Transition : TransitionType>(embeddedHALs:[String:AnyObject]) -> [String:[Representor<Transition>]] {
  var representors = [String:[Representor<Transition>]]()

  func parseEmbedded(embedded:[String:AnyObject]) -> Representor<Transition> {
    return deserializeHAL(embedded)
  }

  for (name, embedded) in embeddedHALs {
    if let embedded = embedded as? [[String:AnyObject]] {
      representors[name] = embedded.map(deserializeHAL)
    } else if let embedded = embedded as? [String:AnyObject] {
      representors[name] = [deserializeHAL(embedded)]
    }
  }

  return representors
}

/// A function to deserialize a HAL structure into a HTTP Transition.
public func deserializeHAL<Transition : TransitionType>(hal:[String:AnyObject]) -> Representor<Transition> {
  var hal = hal

  var links = [String:String]()
  if let halLinks = hal.removeValueForKey("_links") as? [String:[String:AnyObject]] {
    links = parseHALLinks(halLinks)
  }

  var representors = [String:[Representor<Transition>]]()
  if let embedded = hal.removeValueForKey("_embedded") as? [String:AnyObject] {
    representors = parseEmbeddedHALs(embedded)
  }

  return Representor(transitions: nil, representors: representors, attributes: hal, links: links)
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeHAL<Transition : TransitionType>(representor:Representor<Transition>) -> [String:AnyObject] {
  var representation = representor.attributes

  if representor.links.count > 0 {
    var links = [String:[String:String]]()

    for (relation, uri) in representor.links {
      links[relation] = ["href": uri]
    }

    representation["_links"] = links
  }

  if representor.representors.count > 0 {
    var embeddedHALs = [String:[[String:AnyObject]]]()

    for (name, representorSet) in representor.representors {
      embeddedHALs[name] = representorSet.map(serializeHAL)
    }

    representation["_embedded"] = embeddedHALs
  }

  return representation
}
