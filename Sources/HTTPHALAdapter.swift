//
//  HTTPHALAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

func parseHALLinks(_ halLinks: [String: AnyObject]) -> [String: [HTTPTransition]] {
  var links: [String: [HTTPTransition]] = [:]

  for (relation, options) in halLinks {
    if let options = options as? [String: AnyObject],
           let href = options["href"] as? String
    {
      let transition = HTTPTransition(uri: href)
      links[relation] = [transition]
    } else if let options = options as? [[String: AnyObject]] {
      links[relation] = options.flatMap {
        if let href = $0["href"] as? String {
          return HTTPTransition(uri: href)
        }

        return nil
      }
    }
  }

  return links
}


func parseEmbeddedHALs(_ embeddedHALs: [String: AnyObject]) -> [String: [Representor<HTTPTransition>]] {
  var representors = [String: [Representor<HTTPTransition>]]()

  func parseEmbedded(_ embedded:[String: AnyObject]) -> Representor<HTTPTransition> {
    return deserializeHAL(embedded)
  }

  for (name, embedded) in embeddedHALs {
    if let embedded = embedded as? [[String: Any]] {
      representors[name] = embedded.map(deserializeHAL)
    } else if let embedded = embedded as? [String: AnyObject] {
      representors[name] = [deserializeHAL(embedded)]
    }
  }

  return representors
}

/// A function to deserialize a HAL structure into a HTTP Transition.
public func deserializeHAL(_ hal:[String: Any]) -> Representor<HTTPTransition> {
  var hal = hal

  var links: [String: [HTTPTransition]] = [:]
  if let halLinks = hal.removeValue(forKey: "_links") as? [String: AnyObject] {
    links = parseHALLinks(halLinks)
  }

  var representors:[String: [Representor<HTTPTransition>]] = [:]
  if let embedded = hal.removeValue(forKey: "_embedded") as? [String: AnyObject] {
    representors = parseEmbeddedHALs(embedded)
  }

  return Representor(transitions: links, representors: representors, attributes: hal as [String: Any])
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeHAL(_ representor: Representor<HTTPTransition>) -> [String: Any] {
  var representation = representor.attributes

  if !representor.transitions.isEmpty {
    var links: [String: Any] = [:]

    for (relation, transitions) in representor.transitions {
      if transitions.count == 1 {
        links[relation] = ["href": transitions[0].uri]
      } else {
        links[relation] = transitions.map {
          ["href": $0.uri]
        }
      }
    }

    representation["_links"] = links as AnyObject
  }

  if !representor.representors.isEmpty {
    var embeddedHALs: [String: [[String: Any]]] = [:]

    for (name, representorSet) in representor.representors {
      embeddedHALs[name] = representorSet.map(serializeHAL)
    }

    representation["_embedded"] = embeddedHALs as AnyObject
  }

  return representation
}
