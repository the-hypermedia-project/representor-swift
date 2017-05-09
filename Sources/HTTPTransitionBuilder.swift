//
//  HTTPTransitionBuilder.swift
//  Representor
//
//  Created by Kyle Fuller on 23/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation

/// An implementation of TransitionBuilder used by the HTTPTransition
open class HTTPTransitionBuilder : TransitionBuilderType {
  var attributes = InputProperties()
  var parameters = InputProperties()

  /// The suggested contentType that should be used to make the request
  open var method = "POST"
  /// The suggested contentType that should be used to make the request
  open var suggestedContentTypes = [String]()

  init() {
    
  }

  // MARK: Attributes

  /// Adds an attribute with a value or default value
  ///
  /// - parameter name: The name of the attribute
  /// - parameter title: The human readable title of the attribute
  /// - parameter value: The value of the attribute
  /// - parameter defaultValue: The default value of the attribute
  open func addAttribute<T : Any>(_ name: String, title: String? = nil, value: T? = nil, defaultValue: T? = nil, required: Bool? = nil) {
    let property = InputProperty<AnyObject>(title: title, value: value as AnyObject, defaultValue: defaultValue as AnyObject, required: required)
    attributes[name] = property
  }

  /// Adds an attribute
  ///
  /// - parameter name: The name of the attribute
  /// - parameter title: The human readable title of the attribute
  open func addAttribute(_ name: String, title: String? = nil, required: Bool? = nil) {
    let property = InputProperty<AnyObject>(title:title, required:required)
    attributes[name] = property
  }

  // MARK: Parameters

  /// Adds a parameter without a value or default value
  ///
  /// - parameter name: The name of the attribute
  open func addParameter(_ name: String) {
    let property = InputProperty<AnyObject>(value:nil, defaultValue:nil)
    parameters[name] = property
  }

  /// Adds a parameter with a value or default value
  ///
  /// - parameter name: The name of the attribute
  /// - parameter value: The value of the attribute
  /// - parameter value: The default value of the attribute
  open func addParameter<T : Any>(_ name: String, value: T?, defaultValue: T?, required: Bool? = nil) {
    let property = InputProperty<AnyObject>(value: value as AnyObject, defaultValue: defaultValue as AnyObject, required:required)
    parameters[name] = property
  }
}
