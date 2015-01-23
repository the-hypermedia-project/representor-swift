//
//  TransitionBuilder.swift
//  Representor
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public protocol TransitionBuilder {
}

/// A class used to build a transition using a builder pattern
public class HTTPTransitionBuilder : TransitionBuilder {
  var attributes = InputProperties()
  var parameters = InputProperties()

  // MARK: Attributes

  /// Adds an attribute without a value or default value
  ///
  /// :param: name The name of the attribute
  public func addAttribute(name:String) {
    let property = InputProperty<AnyObject>(value:nil, defaultValue:nil)
    attributes[name] = property
  }

  /// Adds an attribute with a value or default value
  ///
  /// :param: name The name of the attribute
  /// :param: value The value of the attribute
  /// :param: value The default value of the attribute
  public func addAttribute<T : AnyObject>(name:String, value:T?, defaultValue:T?) {
    let property = InputProperty<AnyObject>(value:value, defaultValue:defaultValue)
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
  public func addParameter<T : AnyObject>(name:String, value:T?, defaultValue:T?) {
    let property = InputProperty<AnyObject>(value:value, defaultValue:defaultValue)
    parameters[name] = property
  }
}
