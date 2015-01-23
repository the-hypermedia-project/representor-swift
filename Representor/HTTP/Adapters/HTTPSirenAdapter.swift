//
//  SirenAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

private func sirenActionToTransition(action:[String: AnyObject]) -> (name:String, transition:HTTPTransition)? {
  if let name = action["name"] as? String {
    if let href = action["href"] as? String {
      let transition = HTTPTransition(uri: href) { builder in
        if let method = action["method"] as? String {
          builder.method = method
        }

        if let contentType = action["type"] as? String {
          builder.contentType = contentType
        }

        if let fields = action["fields"] as? [[String:AnyObject]] {
          for field in fields {
            if let name = field["name"] as? String {
              if let value = field["value"] as? String {
                builder.addAttribute(name, value: value as NSObject, defaultValue: nil)
              } else {
                builder.addAttribute(name)
              }
            }
          }
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

  return field
}

private func transitionToSirenAction(relation:String, transition:HTTPTransition) -> [String:AnyObject] {
  var action:[String:AnyObject] = [
    "href": transition.uri,
    "name": relation,
    "method": transition.method
  ]

  if let contentType = transition.contentType {
    action["type"] = contentType
  }

  if transition.attributes.count > 0 {
    action["fields"] = map(transition.attributes, inputPropertyToSirenField)
  }

  return action
}

/// A function to deserialize a Siren structure into a HTTP Transition.
public func deserializeSiren(siren:Dictionary<String, AnyObject>) -> Representor<HTTPTransition> {
  var links = Dictionary<String, String>()
  var representors = Dictionary<String, [Representor<HTTPTransition>]>()
  var transitions = [String:HTTPTransition]()
  var attributes = Dictionary<String, AnyObject>()

  if let sirenLinks = siren["links"] as? [Dictionary<String, AnyObject>] {
    for link in sirenLinks {
      if let href = link["href"] as? String {
        if let relations = link["rel"] as? [String] {
          for relation in relations {
            links[relation] = href
          }
        }
      }
    }
  }

  if let entities = siren["entities"] as? [Dictionary<String, AnyObject>] {
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
        transitions[name] = transition
      }
    }
  }

  if let properties = siren["properties"] as? Dictionary<String, AnyObject> {
    attributes = properties
  }

  return Representor<HTTPTransition>(transitions: transitions, representors: representors, attributes: attributes, links: links, metadata: [:])
}

/// A function to serialize a HTTP Representor into a Siren structure
public func serializeSiren(representor:Representor<HTTPTransition>) -> Dictionary<String, AnyObject> {
  var representation = Dictionary<String, AnyObject>()

  if representor.links.count > 0 {
    var links = [Dictionary<String, AnyObject>]()

    for (name, uri) in representor.links {
      links.append(["rel": [name], "href": uri])
    }

    representation["links"] = links
  }

  if representor.representors.count > 0 {
    var entities = [Dictionary<String, AnyObject>]()

    for (relation, representorSet) in representor.representors {
      for representor in representorSet {
        var representation = serializeSiren(representor)
        representation["rel"] = [relation]
        entities.append(representation)
      }
    }

    representation["entities"] = entities
  }

  if representor.attributes.count > 0 {
    representation["properties"] = representor.attributes
  }

  if representor.transitions.count > 0 {
    representation["actions"] = map(representor.transitions, transitionToSirenAction)
  }

  return representation
}
