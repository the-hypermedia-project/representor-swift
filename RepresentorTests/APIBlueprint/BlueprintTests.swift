//
//  BlueprintTests.swift
//  Representor
//
//  Created by Kyle Fuller on 06/01/2015.
//  Copyright (c) 2015 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor


class ResourceGroupTests : XCTestCase {
  var resourceGroup:ResourceGroup!

  override func setUp() {
    resourceGroup = ResourceGroup(name: "Group", description: "Description", resources: [])
  }

  func testName() {
    XCTAssertEqual(resourceGroup.name, "Group")
  }

  func testDescription() {
    XCTAssertEqual(resourceGroup.description!, "Description")
  }

  func testResources() {
    XCTAssertEqual(resourceGroup.resources.count, 0)
  }
}


class ResourceTests : XCTestCase {
  var resource:Resource!

  override func setUp() {
    resource = Resource(name: "Name", description: "Description", uriTemplate: "uri/{template}", parameters: [], actions: [])
  }

  func testName() {
    XCTAssertEqual(resource.name, "Name")
  }

  func testDescription() {
    XCTAssertEqual(resource.description!, "Description")
  }

  func testURIemplate() {
    XCTAssertEqual(resource.uriTemplate, "uri/{template}")
  }

  func testParameters() {
    XCTAssertEqual(resource.parameters.count, 0)
  }

  func testActions() {
    XCTAssertEqual(resource.actions.count, 0)
  }
}


class ActionTests : XCTestCase {
  var action:Action!

  override func setUp() {
    action = Action(name: "Name", description: "Description", method: "GET", parameters: [], uriTemplate: "/users/{username}")
  }

  func testName() {
    XCTAssertEqual(action.name, "Name")
  }

  func testDescription() {
    XCTAssertEqual(action.description!, "Description")
  }

  func testMethod() {
    XCTAssertEqual(action.method, "GET")
  }

  func testParameters() {
    XCTAssertEqual(action.parameters.count, 0)
  }

  func testRelation() {
    XCTAssertNil(action.relation)
  }

  func testURITemplate() {
    XCTAssertEqual(action.uriTemplate!, "/users/{username}")
  }
}


class TransactionExampleTests : XCTestCase {
  var example:TransactionExample!

  override func setUp() {
    example = TransactionExample(name: "Name", description: "Description")
  }

  func testName() {
    XCTAssertEqual(example.name, "Name")
  }

  func testDescription() {
    XCTAssertEqual(example.description!, "Description")
  }
}


class PayloadTests : XCTestCase {
  var payload:Payload!

  override func setUp() {
    payload = Payload(name: "Name", description: "Description")
  }

  func testName() {
    XCTAssertEqual(payload.name, "Name")
  }

  func testDescription() {
    XCTAssertEqual(payload.description!, "Description")
  }
}


class ParameterTests : XCTestCase {
  var parameter:Parameter!

  override func setUp() {
    parameter = Parameter(name: "Name", description: "Description", type: "string", required: true, defaultValue: "hi", example: "hey", values: nil)
  }

  func testName() {
    XCTAssertEqual(parameter.name, "Name")
  }

  func testDescription() {
    XCTAssertEqual(parameter.description!, "Description")
  }

  func testType() {
    XCTAssertEqual(parameter.type!, "string")
  }

  func testRequired() {
    XCTAssertTrue(parameter.required)
  }

  func testDefaultValue() {
    XCTAssertEqual(parameter.defaultValue!, "hi")
  }

  func testExample() {
    XCTAssertEqual(parameter.example!, "hey")
  }

  func testValues() {
    XCTAssertNil(parameter.values)
  }
}


class BlueprintTests : XCTestCase {
  func testLoadingNonExistantBlueprint() {
    let bundle = NSBundle(forClass:object_getClass(self))
    let blueprint = Blueprint(named:"unknown.json", bundle:bundle)
    XCTAssertTrue(blueprint == nil)
  }

  func testParsingBlueprintAST() {
    let bundle = NSBundle(forClass:object_getClass(self))
    let blueprint = Blueprint(named:"blueprint.json", bundle:bundle)!

    XCTAssertEqual(blueprint.name, "Requests API")
    XCTAssertEqual(blueprint.description!, "Following the [Responses](5.%20Responses.md) example, this API will show you how to define multiple requests and what data these requests can bear. Let's demonstrate multiple requests on a trivial example of content negotiation.\n\n## API Blueprint\n\n+ [Previous: Responses](5.%20Responses.md)\n\n+ [This: Raw API Blueprint](https://raw.github.com/apiaryio/api-blueprint/master/examples/6.%20Requests.md)\n\n+ [Next: Parameters](7.%20Parameters.md)\n\n")

    let resourceGroups = blueprint.resourceGroups
    let resourceGroup = resourceGroups[0]
    XCTAssertEqual(resourceGroups.count, 1)
    XCTAssertEqual(resourceGroup.name, "Messages")
    XCTAssertEqual(resourceGroup.description!, "Group of all messages-related resources.\n\n")

    let resource = resourceGroup.resources[0]
    XCTAssertEqual(resourceGroup.resources.count, 1)
    XCTAssertEqual(resource.name, "My Message")
    XCTAssertEqual(resource.description!, "")
    XCTAssertEqual(resource.uriTemplate, "/message")

    let retrieveAction = resource.actions[0]
    let updateAction = resource.actions[1]
    XCTAssertEqual(resource.actions.count, 2)

    XCTAssertEqual(retrieveAction.name, "Retrieve a Message")
    XCTAssertEqual(retrieveAction.description!, "In API Blueprint requests can hold exactly the same kind of information and can be described by exactly the same structure as responses, only with different signature – using the `Request` keyword. The string that follows after the `Request` keyword is a request identifier. Again, using an explanatory and simple naming is the best way to go. \n\n")
    XCTAssertEqual(retrieveAction.method, "GET")

    XCTAssertEqual(retrieveAction.examples.count, 2)

    let example1 = retrieveAction.examples[0]
    XCTAssertEqual(example1.name, "")
    XCTAssertEqual(example1.description!, "")
    XCTAssertEqual(example1.requests.count, 1)
    XCTAssertEqual(example1.responses.count, 1)

    let requestPayload = example1.requests[0]
    XCTAssertEqual(requestPayload.name, "Plain Text Message")
    XCTAssertEqual(requestPayload.description!, "")
    XCTAssertEqual(requestPayload.headers.count, 1)
    XCTAssertEqual(requestPayload.headers[0].name, "Accept")
    XCTAssertEqual(requestPayload.headers[0].value, "text/plain")

    let responsePayload = example1.responses[0]
    XCTAssertEqual(responsePayload.name, "200")
    XCTAssertEqual(responsePayload.description!, "")
    XCTAssertEqual(responsePayload.headers.count, 2)
    XCTAssertEqual(responsePayload.headers[0].name, "Content-Type")
    XCTAssertEqual(responsePayload.headers[0].value, "text/plain")
    XCTAssertEqual(responsePayload.headers[1].name, "X-My-Message-Header")
    XCTAssertEqual(responsePayload.headers[1].value, "42")
    let body = "Hello World!\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    XCTAssertEqual(responsePayload.body!, body)

    let example2 = retrieveAction.examples[1]
    XCTAssertEqual(example2.name, "")
    XCTAssertEqual(example2.description!, "")
    XCTAssertEqual(example2.requests.count, 1)
    XCTAssertEqual(example2.responses.count, 1)

    let parameter = retrieveAction.parameters[0]
    XCTAssertEqual(parameter.name, "id")
    XCTAssertEqual(parameter.description!, "An unique identifier of the message.")
    XCTAssertEqual(parameter.type!, "number")
    XCTAssertTrue(parameter.required)
    XCTAssertEqual(parameter.defaultValue!, "")
    XCTAssertEqual(parameter.example!, "1")
    XCTAssertEqual(parameter.values!, [])

    XCTAssertEqual(updateAction.name, "Update a Message")
    XCTAssertEqual(updateAction.description!, "")
    XCTAssertEqual(updateAction.method, "PUT")
  }
}
