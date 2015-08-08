//
//  HTTPGitHubAdapter.swift
//  Representor
//
//  Created by Z on 8/5/15.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

let selfTranstitionKey = "url"
let transitionKeySuffix = "_url"
let selfRelationType = "self"

// Check whether a GitHub object property is a transition
private func isGitHubTransition(key: String, value: AnyObject) -> Bool {
  if !(value is String) {
    return false
  }
  
  if key == selfTranstitionKey || key.hasSuffix(transitionKeySuffix) {
    return true
  }
  
  return false
}

// Create a link from a GitHub transition
private func parseGitHubTransition(key: String, value: AnyObject) -> (relation:String, transition: HTTPTransition) {
  // relation type
  let relation: String

  if (key == selfTranstitionKey) {
    relation = selfRelationType
  }
  else {
    var key = key
    let range = key.rangeOfString(transitionKeySuffix, options: .BackwardsSearch)
    key.removeRange(range!)
    relation = key
  }
  
  let href = value as? String
  var transition = HTTPTransition(uri: href!)
  return (relation, transition)
}

// Check whether a GitHub object property is an embedded resource
private func isGitHubEmbeddedResource(key: String, value: AnyObject) -> Bool {
  if let embedded = value as? Dictionary<String, AnyObject> {
    for (embeddedKey, embeddedValue) in embedded {
      if isGitHubTransition(embeddedKey, embeddedValue) {
        return true
      }
    }
  }
  
  return false;
}

// Creates a representor from a GitHub embedded
private func parseGitHubEmbeddedResource(key: String, value: AnyObject) -> (relation: String, representor: Representor<HTTPTransition>, transition: HTTPTransition) {

  let embedded = deserializeGitHub((value as? Dictionary<String, AnyObject>)!)
  let transition = embedded.transitions[selfRelationType]
  
  return (key, embedded, transition!)
}

/// Deserialize GitHub application/vnd.github.v3+json
public func deserializeGitHub(github:[String:AnyObject]) -> Representor<HTTPTransition> {
  var transitions = [String:HTTPTransition]()
  var representors = [String:[Representor<HTTPTransition>]]()
  var attributes = [String:AnyObject]()
  
  for (key, value) in github {

    // Transitions
    if isGitHubTransition(key, value) {
      let link = parseGitHubTransition(key, value)
      transitions[link.relation] = link.transition
      continue
    }
    
    // Embedded resources
    if isGitHubEmbeddedResource(key, value) {
      let embedded = parseGitHubEmbeddedResource(key, value)
      representors[embedded.relation] = [embedded.representor]
      transitions[embedded.relation] = embedded.transition
      
      continue
    }
    
    // Attributes
    attributes[key] = value
  }
  
  return Representor<HTTPTransition>(transitions: transitions, representors: representors, attributes: attributes)
}

