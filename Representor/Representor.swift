//
//  Representor.swift
//  Representor
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

public struct Representor<Transition : TransitionType> : Equatable, Hashable {
  public typealias Builder = RepresentorBuilder<Transition>

  /// The transitions available for the representor
  public var transitions:[String:Transition]

  /// The separate representors embedded in the current representor.
  public var representors:[String:[Representor]]

  public var metadata:[String:String]

  /// The attributes of the representor
  public var attributes:[String:AnyObject]

  public init(transitions:[String:Transition]? = nil, representors:[String:[Representor]]? = nil, attributes:[String:AnyObject]? = nil, metadata:[String:String]? = nil) {
    self.transitions = transitions ?? [:]
    self.representors = representors ?? [:]
    self.attributes = attributes ?? [:]
    self.metadata = metadata ?? [:]
  }

  public var hashValue:Int {
    return transitions.count + representors.count + metadata.count + attributes.count
  }

  /// An extension to Representor to provide a builder interface for creating a Representor.
  public init(_ block:((builder:Builder) -> ())) {
    // This should belong in an extension, but due to a bug in the symbol
    // mangler in the Swift compiler it results in the symbol being incorrectly
    // mangled when being used from an extension.
    //
    // Swift ¯\_(ツ)_/¯
    let builder = Builder()

    block(builder:builder)

    self.transitions = builder.transitions
    self.representors = builder.representors
    self.attributes = builder.attributes
    self.metadata = builder.metadata
  }
}

public func ==<Transition : TransitionType>(lhs:[String:[Representor<Transition>]], rhs:[String:[Representor<Transition>]]) -> Bool {
  // There is a strange Swift bug where you cannot compare a
  // dictionary which has an array of objects which conform to Equatable.
  // So to be clear, that's comparing the following:
  //
  //     [Equatable: [Equatable]]
  //
  // If one day this problem is solved in a newer version of Swift,
  // this method can be removed and the default == implementation can be used.
  //
  // Swift ¯\_(ツ)_/¯

  if lhs.count != rhs.count {
    return false
  }

  for (key, value) in lhs {
    if let rhsValue = rhs[key] {
      if (value != rhsValue) {
        return false
      }
    } else {
      return false
    }
  }

  return true
}

public func ==<Transition : TransitionType>(lhs:Representor<Transition>, rhs:Representor<Transition>) -> Bool {
  return (
    lhs.transitions == rhs.transitions &&
    lhs.representors == rhs.representors &&
    lhs.metadata == rhs.metadata &&
    (lhs.attributes as NSObject) == (rhs.attributes as NSObject)
  )
}
