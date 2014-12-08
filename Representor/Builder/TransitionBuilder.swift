//
//  TransitionBuilder.swift
//  Representor
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public class TransitionBuilder {
  var attributes = InputProperties()
  var parameters = InputProperties()

  // MARK: Attributes

  public func addAttribute(name:String) {
    let property = InputProperty<AnyObject>(value:nil, defaultValue:nil)
    attributes[name] = property
  }

  public func addAttribute<T : AnyObject>(name:String, value:T?, defaultValue:T?) {
    let property = InputProperty<AnyObject>(value:value, defaultValue:defaultValue)
    attributes[name] = property
  }

  // MARK: Parameters

  public func addParameter(name:String) {
    let property = InputProperty<AnyObject>(value:nil, defaultValue:nil)
    parameters[name] = property
  }

  public func addParameter<T : AnyObject>(name:String, value:T?, defaultValue:T?) {
    let property = InputProperty<AnyObject>(value:value, defaultValue:defaultValue)
    parameters[name] = property
  }
}

extension Transition {
  /// An extension to Transition to provide a builder interface for creating a Transition.
  public init(uri:String, _ block:((builder:TransitionBuilder) -> ())) {
    let builder = TransitionBuilder()

    block(builder: builder)

    self.uri = uri
    self.attributes = builder.attributes
    self.parameters = builder.parameters
  }
}
