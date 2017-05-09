//
//  Transition.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public struct InputProperty: Equatable {
  public let title: String?

  public let defaultValue: Any?
  public let value: Any?
  public let required: Bool?

  // TODO: Define validators

  public init<T>(title: String? = nil, value: T? = nil, defaultValue: T? = nil, required: Bool? = nil) {
    self.title = title
    self.value = value
    self.defaultValue = defaultValue
    self.required = required
  }
}

public func ==(lhs: InputProperty, rhs: InputProperty) -> Bool {
  return (
    lhs.title == rhs.title &&
    lhs.defaultValue as? NSObject == rhs.defaultValue as? NSObject &&
    lhs.value as? NSObject == rhs.value as? NSObject &&
    lhs.required == rhs.required
  )
}

public typealias InputProperties = [String: InputProperty]

/** Transition instances encapsulate information about interacting with links and forms. */
public protocol TransitionType: Equatable, Hashable {
  associatedtype Builder = TransitionBuilderType

  init(uri: String, attributes: InputProperties?, parameters: InputProperties?)
  init(uri: String, _ block: ((_ builder:Builder) -> ()))

  var uri: String { get }

  var attributes: InputProperties { get }
  var parameters: InputProperties { get }
}
