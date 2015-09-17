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
  /// The added transitions
  private(set) public var transitions = [String:Transition]()

  /// The added representors
  private(set) public var representors = [String:[Representor<Transition>]]()

  /// The added attributes
  private(set) public var attributes = [String:AnyObject]()

  /// The added metadata
  private(set) public var metadata = [String:String]()

  /// Adds an attribute
  ///
  /// - parameter name: The name of the attribute
  /// - parameter value: The value of the attribute
  public func addAttribute(name:String, value:AnyObject) {
    attributes[name] = value
  }

  // MARK: Representors

  /// Adds an embedded representor
  ///
  /// - parameter name: The name of the representor
  /// - parameter representor: The representor
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
  /// - parameter name: The name of the representor
  /// - parameter builder: A builder to build the representor
  public func addRepresentor(name:String, block:((builder:RepresentorBuilder<Transition>) -> ())) {
    addRepresentor(name, representor:Representor<Transition>(block))
  }

  // MARK: Transition

  /// Adds a transition
  ///
  /// - parameter name: The name (or relation) for the transition
  /// - parameter transition: The transition
  public func addTransition(name:String, _ transition:Transition) {
    transitions[name] = transition
  }

  /// Adds a transition with a URI
  ///
  /// - parameter name: The name (or relation) for the transition
  /// - parameter uri: The URI of the transition
  public func addTransition(name:String, uri:String) {
    let transition = Transition(uri: uri, attributes:[:], parameters:[:], metadata:[:])
    transitions[name] = transition
  }

  /// Adds a transition with a URI using a builder
  ///
  /// - parameter name: The name (or relation) for the transition
  /// - parameter uri: The URI of the transition
  /// - parameter builder: The builder used to create the transition
  public func addTransition(name:String, uri:String, builder:((Transition.Builder) -> ())) {
    let transition = Transition(uri: uri, builder)
    transitions[name] = transition
  }

  // MARK: Metadata

  /// Adds an piece of metadata
  ///
  /// - parameter key: The key for the metadata
  /// - parameter value: The value of the key
  public func addMetaData(key:String, value:String) {
    metadata[key] = value
  }
}
