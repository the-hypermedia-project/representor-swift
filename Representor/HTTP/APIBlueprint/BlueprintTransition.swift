//
//  BlueprintTransition.swift
//  Representor
//
//  Created by Kyle Fuller on 28/01/2015.
//  Copyright (c) 2015 Apiary LTD. All rights reserved.
//

import Foundation

extension Array {
  func contains<T : Equatable>(obj: T) -> Bool {
    let filtered = self.filter {$0 as? T == obj}
    return filtered.count > 0
  }
}

extension Resource {
  func transition(actionName:String) -> HTTPTransition? {
    func filterAction(action:Action) -> Bool {
      if let relationName = action.relation {
        if relationName == actionName {
          return true
        }
      }

      if action.name == actionName {
        return true
      }

      return false
    }

    let action = actions.filter(filterAction).first
    if let action = action {
      return HTTPTransition(uri: action.uriTemplate ?? uriTemplate) { builder in
        builder.method = action.method

        let addParameter = { (parameter:Parameter) -> Void in
          let value = parameter.example
          let defaultValue = (parameter.defaultValue ?? nil) as NSObject?
          builder.addParameter(parameter.name, value:value, defaultValue:defaultValue)
        }

        action.parameters.map(addParameter)
        let parameters = action.parameters.map{ $0.name }
        self.parameters.filter { !parameters.contains($0.name) }.map(addParameter)
      }
    }

    return nil
  }
}

/// An extension to Blueprint providing transition conversion
extension Blueprint {
  /// Returns a HTTPTransition representation of an action in a resource
  public func transition(resourceName:String, action actionName:String) -> HTTPTransition? {
    let resources = resourceGroups.map { resourceGroup in resourceGroup.resources }.reduce([], combine: +)
    let resource = resources.filter { resource in resource.name == resourceName }.first
    if let resource = resource {
      return resource.transition(actionName)
    }

    return nil
  }
}
