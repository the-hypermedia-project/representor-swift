//
//  HTTPHALAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

/// https://tools.ietf.org/html/draft-kelly-json-hal-07#section-5.5
private let AllowedHALLinkOptions = [
	"templated", "type", "deprecation",
	"name", "profile", "title", "hreflang"
]

private func parseHALLinkAttributes(options: [String:AnyObject], builder: HTTPTransitionBuilder) {
	for (key, value) in options {
		guard AllowedHALLinkOptions.contains(key) else { continue }
		builder.addAttribute(key, title: nil, value: value, defaultValue: nil, required: nil)
	}
}

func parseHALLinks(halLinks:[String:AnyObject]) -> [String:[HTTPTransition]] {
  var links = [String:[HTTPTransition]]()

  for (relation, options) in halLinks {
    if let options = options as? [String:AnyObject],
           href = options["href"] as? String
    {
			let transition = HTTPTransition(uri: href, { (builder) in
				parseHALLinkAttributes(options, builder: builder)
			})
      links[relation] = [transition]
    } else if let options = options as? [[String:AnyObject]] {
      links[relation] = options.flatMap {
				let transitionOptions = $0
        if let href = $0["href"] as? String {
					let transition = HTTPTransition(uri: href, { (builder) in
						parseHALLinkAttributes(transitionOptions, builder: builder)
					})
          return transition
        }

        return nil
      }
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

  var links = [String:[HTTPTransition]]()
  if let halLinks = hal.removeValueForKey("_links") as? [String:AnyObject] {
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
    var links = [String:AnyObject]()

    for (relation, transitions) in representor.transitions {
      if transitions.count == 1 {
        links[relation] = ["href": transitions[0].uri]
      } else {
        links[relation] = transitions.map {
          ["href": $0.uri]
        }
      }
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
