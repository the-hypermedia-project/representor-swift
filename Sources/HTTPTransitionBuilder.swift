//
//  HTTPTransitionBuilder.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

/// An implementation of TransitionBuilder used by the HTTPTransition
public class HTTPTransitionBuilder : TransitionBuilderType {
  var attributes = InputProperties()
  var parameters = InputProperties()

  /// The suggested contentType that should be used to make the request
  public var method = "POST"
  /// The suggested contentType that should be used to make the request
  public var suggestedContentTypes = [String]()

  init() {
    
  }

  // MARK: Attributes

  /// Adds an attribute with a value or default value
  ///
  /// - parameter name: The name of the attribute
  /// - parameter title: The human readable title of the attribute
  /// - parameter value: The value of the attribute
  /// - parameter defaultValue: The default value of the attribute
  public func addAttribute(_ name: String, title: String? = nil, value: Any? = nil, defaultValue: Any? = nil, required: Bool? = nil) {
    let property = InputProperty(title: title, value: value, defaultValue: defaultValue, required: required)
    attributes[name] = property
  }

  // MARK: Parameters

  /// Adds a parameter with a value or default value
  ///
  /// - parameter name: The name of the attribute
  /// - parameter value: The value of the attribute
  /// - parameter value: The default value of the attribute
  public func addParameter(_ name: String, value: Any? = nil, defaultValue: Any? = nil, required: Bool? = nil) {
    let property = InputProperty(value: value, defaultValue: defaultValue, required:required)
    parameters[name] = property
  }
}
