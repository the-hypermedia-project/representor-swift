//
//  SirenAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

private func sirenFieldToAttribute(_ builder: HTTPTransitionBuilder) -> (_ field: [String: Any]) -> Void {
  return { field in
    if let name = field["name"] as? String {
      let title = field["title"] as? String
      let value: Any? = field["value"]

      builder.addAttribute(name, title: title, value: value, defaultValue: nil)
    }
  }
}

private func sirenActionToTransition(_ action: [String: Any]) -> (name: String, transition: HTTPTransition)? {
  if let name = action["name"] as? String {
    if let href = action["href"] as? String {
      let transition = HTTPTransition(uri: href) { builder in
        if let method = action["method"] as? String {
          builder.method = method
        }

        if let contentType = action["type"] as? String {
          builder.suggestedContentTypes = [contentType]
        }

        if let fields = action["fields"] as? [[String: Any]] {
          fields.forEach(sirenFieldToAttribute(builder))
        }
      }

      return (name, transition)
    }
  }

  return nil
}

private func inputPropertyToSirenField(_ name: String, inputProperty: InputProperty<AnyObject>) -> [String: AnyObject] {
  var field = [
    "name": name
  ]

  if let value: AnyObject = inputProperty.value {
    field["value"] = "\(value)"
  }

  if let title = inputProperty.title {
    field["title"] = title
  }

  return field as [String : AnyObject]
}

private func transitionToSirenAction(_ relation: String, transition: HTTPTransition) -> [String: Any] {
  var action: [String: AnyObject] = [
    "href": transition.uri as AnyObject,
    "name": relation as AnyObject,
    "method": transition.method as AnyObject
  ]

  if let contentType = transition.suggestedContentTypes.first {
    action["type"] = contentType as AnyObject
  }

  if transition.attributes.count > 0 {
    action["fields"] = transition.attributes.map(inputPropertyToSirenField) as NSArray
  }

  return action
}

/// A function to deserialize a Siren structure into a HTTP Transition.
public func deserializeSiren(_ siren: [String: Any]) -> Representor<HTTPTransition> {
  var representors: [String: [Representor<HTTPTransition>]] = [:]
  var transitions: [String: [HTTPTransition]] = [:]
  var attributes: [String: Any] = [:]

  if let sirenLinks = siren["links"] as? [[String: Any]] {
    for link in sirenLinks {
      if let href = link["href"] as? String {
        if let relations = link["rel"] as? [String] {
          for relation in relations {
            transitions[relation] = [HTTPTransition(uri: href)]
          }
        }
      }
    }
  }

  if let entities = siren["entities"] as? [[String: Any]] {
    for entity in entities {
      let representor = deserializeSiren(entity)

      if let relations = entity["rel"] as? [String] {
        for relation in relations {
          if var reps = representors[relation] {
            reps.append(representor)
            representors[relation] = reps
          } else {
            representors[relation] = [representor]
          }
        }
      }
    }
  }

  if let actions = siren["actions"] as? [[String: Any]] {
    for action in actions {
      if let (name, transition) = sirenActionToTransition(action) {
        transitions[name] = [transition]
      }
    }
  }

  if let properties = siren["properties"] as? [String: Any] {
    attributes = properties
  }

  return Representor<HTTPTransition>(transitions: transitions, representors: representors, attributes: attributes)
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeSiren(_ representor: Representor<HTTPTransition>) -> [String: Any] {
  var representation: [String: Any] = [:]

  if !representor.representors.isEmpty {
    var entities: [[String: Any]] = []

    for (relation, representorSet) in representor.representors {
      for representor in representorSet {
        var representation = serializeSiren(representor)
        representation["rel"] = [relation]
        entities.append(representation)
      }
    }

    representation["entities"] = entities as AnyObject
  }

  if !representor.attributes.isEmpty {
    representation["properties"] = representor.attributes as AnyObject
  }

  var links: [[String: Any]] = []
  var actions: [[String: Any]] = []

  for (relation, transitions) in representor.transitions {
    for transition in transitions {
      if transition.method == "GET" {
        links.append(["rel": [relation], "href": transition.uri])
      } else {
        actions.append(transitionToSirenAction(relation, transition: transition))
      }
    }
  }

  if !links.isEmpty {
    representation["links"] = links as AnyObject
  }

  if !actions.isEmpty {
    representation["actions"] = actions as AnyObject
  }

  return representation
}
