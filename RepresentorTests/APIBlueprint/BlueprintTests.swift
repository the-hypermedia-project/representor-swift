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

    XCTAssertEqual(blueprint.name, "Polls")
    XCTAssertTrue(blueprint.description!.hasPrefix("Polls is a simple API allowing consumers to view polls and vote in them."))

    let resourceGroups = blueprint.resourceGroups
    let resourceGroup = resourceGroups[1]
    XCTAssertEqual(resourceGroups.count, 2)
    XCTAssertEqual(resourceGroup.name, "Question")
    XCTAssertTrue(resourceGroup.description!.hasPrefix("Resources related to questions in the API."))

    let resource = resourceGroup.resources[0]
    XCTAssertEqual(resourceGroup.resources.count, 3)
    XCTAssertEqual(resource.name, "Question")
    XCTAssertEqual(resource.uriTemplate, "/questions/{question_id}")

    let retrieveAction = resource.actions[0]
    XCTAssertEqual(resource.actions.count, 1)

    XCTAssertEqual(retrieveAction.name, "View a Questions Detail")
    XCTAssertEqual(retrieveAction.method, "GET")

    XCTAssertEqual(retrieveAction.examples.count, 1)

    let example1 = retrieveAction.examples[0]
    XCTAssertEqual(example1.name, "")
    XCTAssertEqual(example1.description!, "")
    XCTAssertEqual(example1.requests.count, 0)
    XCTAssertEqual(example1.responses.count, 1)

    let responsePayload = example1.responses[0]
    XCTAssertEqual(responsePayload.name, "200")
    XCTAssertEqual(responsePayload.description!, "")
    XCTAssertEqual(responsePayload.headers.count, 1)
    XCTAssertEqual(responsePayload.headers[0].name, "Content-Type")
    XCTAssertEqual(responsePayload.headers[0].value, "application/json")

    // Test the choices are parsed in resources
    XCTAssertEqual(resource.content.count, 1)

    // Test the choices are parsed in payloads
    let questionsResource = resourceGroup.resources[2]
    let questionsAction = questionsResource.actions[0]
    let questionsResponseExample = questionsAction.examples[0].responses[0]
    XCTAssertEqual(questionsResource.name, "Questions Collection")
    XCTAssertEqual(questionsResponseExample.content.count, 1)
  }

  func testParsingMetadataFromAST() {
    let bundle = NSBundle(forClass:object_getClass(self))
    let blueprint = Blueprint(named:"blueprint.json", bundle:bundle)!

    let format = blueprint.metadata[0]
    let host = blueprint.metadata[1]

    XCTAssertEqual(format.name, "FORMAT")
    XCTAssertEqual(format.value, "1A")

    XCTAssertEqual(host.name, "HOST")
    XCTAssertEqual(host.value, "https://polls.apiblueprint.org/")
  }
}
