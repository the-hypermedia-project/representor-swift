//
//  SirenAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

private func sirenFieldToAttribute(builder: HTTPTransitionBuilder) -> (field:[String:AnyObject]) -> Void {
  return { field in
    if let name = field["name"] as? String {
      let title = field["title"] as? String
      let value:AnyObject? = field["value"]

      builder.addAttribute(name, title: title, value: value, defaultValue: nil)
    }
  }
}

private func sirenActionToTransition(action:[String: AnyObject]) -> (name:String, transition:HTTPTransition)? {
  if let name = action["name"] as? String {
    if let href = action["href"] as? String {
      let transition = HTTPTransition(uri: href) { builder in
        if let method = action["method"] as? String {
          builder.method = method
        }

        if let contentType = action["type"] as? String {
          builder.suggestedContentTypes = [contentType]
        }

        if let fields = action["fields"] as? [[String:AnyObject]] {
          fields.forEach(sirenFieldToAttribute(builder))
        }
      }

      return (name, transition)
    }
  }

  return nil
}

private func inputPropertyToSirenField(name:String, inputProperty:InputProperty<AnyObject>) -> [String:AnyObject] {
  var field = [
    "name": name
  ]

  if let value: AnyObject = inputProperty.value {
    field["value"] = "\(value)"
  }

  if let title = inputProperty.title {
    field["title"] = title
  }

  return field
}

private func transitionToSirenAction(relation:String, transition:HTTPTransition) -> [String:AnyObject] {
  var action:[String:AnyObject] = [
    "href": transition.uri,
    "name": relation,
    "method": transition.method
  ]

  if let contentType = transition.suggestedContentTypes.first {
    action["type"] = contentType
  }

  if transition.attributes.count > 0 {
    action["fields"] = transition.attributes.map(inputPropertyToSirenField)
  }

  return action
}

/// A function to deserialize a Siren structure into a HTTP Transition.
public func deserializeSiren(siren:[String:AnyObject]) -> Representor<HTTPTransition> {
  var representors = [String:[Representor<HTTPTransition>]]()
  var transitions = [String:[HTTPTransition]]()
  var attributes = [String:AnyObject]()

  if let sirenLinks = siren["links"] as? [[String:AnyObject]] {
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

  if let entities = siren["entities"] as? [[String:AnyObject]] {
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

  if let actions = siren["actions"] as? [[String:AnyObject]] {
    for action in actions {
      if let (name, transition) = sirenActionToTransition(action) {
        transitions[name] = [transition]
      }
    }
  }

  if let properties = siren["properties"] as? [String:AnyObject] {
    attributes = properties
  }

  return Representor<HTTPTransition>(transitions: transitions, representors: representors, attributes: attributes)
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeSiren(representor:Representor<HTTPTransition>) -> [String:AnyObject] {
  var representation = [String:AnyObject]()

  if !representor.representors.isEmpty {
    var entities = [[String:AnyObject]]()

    for (relation, representorSet) in representor.representors {
      for representor in representorSet {
        var representation = serializeSiren(representor)
        representation["rel"] = [relation]
        entities.append(representation)
      }
    }

    representation["entities"] = entities
  }

  if !representor.attributes.isEmpty {
    representation["properties"] = representor.attributes
  }

  var links = [[String:AnyObject]]()
  var actions = [[String:AnyObject]]()

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
    representation["links"] = links
  }

  if !actions.isEmpty {
    representation["actions"] = actions
  }

  return representation
}
