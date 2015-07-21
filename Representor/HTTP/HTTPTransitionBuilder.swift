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
  /// :param: name The name of the attribute
  /// :param: title The human readable title of the attribute
  /// :param: value The value of the attribute
  /// :param: defaultValue The default value of the attribute
  public func addAttribute<T : AnyObject>(name:String, title:String? = nil, value:T? = nil, defaultValue:T? = nil, required:Bool? = nil) {
    let property = InputProperty<AnyObject>(title:title, value:value, defaultValue:defaultValue, required:required)
    attributes[name] = property
  }

  /// Adds an attribute
  ///
  /// :param: name The name of the attribute
  /// :param: title The human readable title of the attribute
  public func addAttribute(name:String, title:String? = nil, required:Bool? = nil) {
    let property = InputProperty<AnyObject>(title:title, required:required)
    attributes[name] = property
  }

  // MARK: Parameters

  /// Adds a parameter without a value or default value
  ///
  /// :param: name The name of the attribute
  public func addParameter(name:String) {
    let property = InputProperty<AnyObject>(value:nil, defaultValue:nil)
    parameters[name] = property
  }

  /// Adds a parameter with a value or default value
  ///
  /// :param: name The name of the attribute
  /// :param: value The value of the attribute
  /// :param: value The default value of the attribute
  public func addParameter<T : AnyObject>(name:String, value:T?, defaultValue:T?, required:Bool? = nil) {
    let property = InputProperty<AnyObject>(value:value, defaultValue:defaultValue, required:required)
    parameters[name] = property
  }
}
