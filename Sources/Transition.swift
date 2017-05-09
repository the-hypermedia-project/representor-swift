//
//  Transition.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public struct InputProperty<T: AnyObject> : Equatable {
  public let title: String?

  public let defaultValue: T?
  public let value: T?
  public let required: Bool?

  // TODO: Define validators

  public init(title: String? = nil, value: T? = nil, defaultValue: T? = nil, required: Bool? = nil) {
    self.title = title
    self.value = value
    self.defaultValue = defaultValue
    self.required = required
  }
}

public func ==<T : AnyObject>(lhs: InputProperty<T>, rhs: InputProperty<T>) -> Bool {
  return (
    lhs.title == rhs.title &&
    lhs.defaultValue as? NSObject == rhs.defaultValue as? NSObject &&
    lhs.value as? NSObject == rhs.value as? NSObject &&
    lhs.required == rhs.required
  )
}

public typealias InputProperties = [String: InputProperty<AnyObject>]

/** Transition instances encapsulate information about interacting with links and forms. */
public protocol TransitionType: Equatable, Hashable {
  associatedtype Builder = TransitionBuilderType

  init(uri: String, attributes: InputProperties?, parameters: InputProperties?)
  init(uri: String, _ block: ((_ builder:Builder) -> ()))

  var uri: String { get }

  var attributes: InputProperties { get }
  var parameters: InputProperties { get }
}
