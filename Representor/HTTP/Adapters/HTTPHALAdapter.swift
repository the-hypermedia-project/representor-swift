//
//  HTTPHALAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

func parseHALLinks(halLinks:[String:[String:AnyObject]]) -> [String:HTTPTransition] {
  var links = [String:HTTPTransition]()

  for (link, options) in halLinks {
    if let href = options["href"] as? String {
      links[link] = HTTPTransition(uri: href)
    }
  }

  return links
}


func parseEmbeddedHALs(embeddedHALs:[String:AnyObject]) -> [String:[Representor<HTTPTransition>]] {
  var representors = [String:[Representor<HTTPTransition>]]()

  func parseEmbedded(embedded:[String:AnyObject]) -> Representor<HTTPTransition> {
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
public func deserializeHAL(hal:[String:AnyObject]) -> Representor<HTTPTransition> {
  var hal = hal

  var links = [String:HTTPTransition]()
  if let halLinks = hal.removeValueForKey("_links") as? [String:[String:AnyObject]] {
    links = parseHALLinks(halLinks)
  }

  var representors = [String:[Representor<HTTPTransition>]]()
  if let embedded = hal.removeValueForKey("_embedded") as? [String:AnyObject] {
    representors = parseEmbeddedHALs(embedded)
  }

  return Representor(transitions: links, representors: representors, attributes: hal)
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeHAL(representor:Representor<HTTPTransition>) -> [String:AnyObject] {
  var representation = representor.attributes

  if !representor.transitions.isEmpty {
    var links = [String:[String:String]]()

    for (relation, transition) in representor.transitions {
      links[relation] = ["href": transition.uri]
    }

    representation["_links"] = links
  }

  if !representor.representors.isEmpty {
    var embeddedHALs = [String:[[String:AnyObject]]]()

    for (name, representorSet) in representor.representors {
      embeddedHALs[name] = representorSet.map(serializeHAL)
    }

    representation["_embedded"] = embeddedHALs
  }

  return representation
}
