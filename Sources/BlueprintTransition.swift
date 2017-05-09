//
//  BlueprintTransition.swift
//  Representor
//
//  Created by Kyle Fuller on 28/01/2015.
//  Copyright (c) 2015 Apiary LTD. All rights reserved.
//

import Foundation

extension Resource {
  func transition(_ actionName:String) -> HTTPTransition? {
    func filterAction(_ action:Action) -> Bool {
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

    if let action = actions.filter(filterAction).first {
      return HTTPTransition.from(resource: self, action: action)
    }

    return nil
  }
}

func parseAttributes(_ dataStructure: [String: AnyObject], builder:HTTPTransitionBuilder) {
  func isPropertyRequired(_ property: [String: AnyObject]) -> Bool? {
    if let valueDefinition = property["valueDefinition"] as? [String:AnyObject],
           let typeDefinition = valueDefinition["typeDefinition"] as? [String:AnyObject],
           let attributes = typeDefinition["attributes"] as? [String]
    {
      return attributes.contains("required")
    }

    return nil
  }

  if let sections = dataStructure["sections"] as? [[String:AnyObject]] {
    if let section = sections.first {
      if (section["class"] as? String) ?? "" == "memberType" {
        if let content = section["content"] as? [[String:AnyObject]] {
          for property in content {
            if ((property["class"] as? String) ?? "") != "property" {
              continue
            }

            if let content = property["content"] as? [String:AnyObject],
                   let name = content["name"] as? [String:AnyObject],
                   let literal = name["literal"] as? String
            {
              builder.addAttribute(literal, value: "", defaultValue: "", required: isPropertyRequired(content))
            }
          }
        }
      }
    }
  }
}

extension HTTPTransition {
  public static func from(resource:Resource, action:Action, URL:String? = nil) -> HTTPTransition {
    return HTTPTransition(uri: URL ?? action.uriTemplate ?? resource.uriTemplate) { builder in
      builder.method = action.method

      func addParameter(_ parameter:Parameter) {
        let value = parameter.example
        let defaultValue = (parameter.defaultValue ?? nil) as NSObject?
        builder.addParameter(parameter.name, value: value as AnyObject, defaultValue: defaultValue as AnyObject, required:parameter.required)
      }

      action.parameters.forEach(addParameter)

      let parameters = action.parameters.map { $0.name }
      let missingParentParameters = resource.parameters.filter {
        !parameters.contains($0.name)
      }
      missingParentParameters.forEach(addParameter)

      // Let's look at the MSON structure, we currently only look for the members
      // of an object since that's only what we can put in a transitions
      // attributes in the Representor
      let dataStructure = action.content.filter { ($0["element"] as? String) == "dataStructure" }.first
      if let dataStructure = dataStructure {
        parseAttributes(dataStructure, builder: builder)
      }
    }
  }
}

/// An extension to Blueprint providing transition conversion
extension Blueprint {
  /// Returns a HTTPTransition representation of an action in a resource
  public func transition(_ resourceName:String, action actionName:String) -> HTTPTransition? {
    let resources = resourceGroups.map { resourceGroup in resourceGroup.resources }.reduce([], +)
    let resource = resources.filter { resource in resource.name == resourceName }.first
    if let resource = resource {
      return resource.transition(actionName)
    }

    return nil
  }
}
