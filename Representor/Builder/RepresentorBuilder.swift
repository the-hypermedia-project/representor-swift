//
//  RepresentorBuilder.swift
//  Representor
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

/// A class used to build a representor using a builder pattern
public class RepresentorBuilder<Transition : TransitionType> {
  var transitions = [String:Transition]()
  var representors = [String:[Representor<Transition>]]()
  var attributes = [String:AnyObject]()
  var links = [String:String]()
  var metadata = [String:String]()

  /// Adds an attribute
  ///
  /// :param: name The name of the attribute
  /// :param: value The value of the attribute
  public func addAttribute(name:String, value:AnyObject) {
    attributes[name] = value
  }

  // MARK: Representors

  /// Adds an embedded representor
  ///
  /// :param: name The name of the representor
  /// :param: representor The representor
  public func addRepresentor(name:String, representor:Representor<Transition>) {
    if var representorSet = representors[name] {
      representorSet.append(representor)
      representors[name] = representorSet
    } else{
      representors[name] = [representor]
    }
  }

  /// Adds an embedded representor using the builder pattern
  ///
  /// :param: name The name of the representor
  /// :param: builder A builder to build the representor
  public func addRepresentor(name:String, block:((builder:RepresentorBuilder<Transition>) -> ())) {
    addRepresentor(name, representor:Representor<Transition>(block))
  }

  // MARK: Transition

  /// Adds a transition
  ///
  /// :param: name The name (or relation) for the transition
  /// :param: transition The transition
  public func addTransition(name:String, _ transition:Transition) {
    transitions[name] = transition
  }

  /// Adds a transition with a URI
  ///
  /// :param: name The name (or relation) for the transition
  /// :param: uri The URI of the transition
  public func addTransition(name:String, uri:String) {
    let transition = Transition(uri: uri, attributes:[:], parameters:[:])
    transitions[name] = transition
  }

  /// Adds a transition with a URI using a builder
  ///
  /// :param: name The name (or relation) for the transition
  /// :param: uri The URI of the transition
  /// :param: builder The builder used to create the transition
  public func addTransition(name:String, uri:String, builder:((Transition.Builder) -> ())) {
    let transition = Transition(uri: uri, builder)
    transitions[name] = transition
  }

  // MARK: Links

  /// Adds a link
  ///
  /// :param: name The name (or relation) for the link
  /// :param: uri The URI of the link
  public func addLink(name:String, uri:String) {
    links[name] = uri
  }

  // MARK: Metadata

  /// Adds an piece of metadata
  ///
  /// :param: key The key for the metadata
  /// :param: value The value of the key
  public func addMetaData(key:String, value:String) {
    metadata[key] = value
  }
}
