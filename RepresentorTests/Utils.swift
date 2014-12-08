//
//  Utils.swift
//  Representor
//
//  Created by Kyle Fuller on 18/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import Representor

func JSONFixture(named:String, forObject:AnyObject) -> Dictionary<String, AnyObject> {
  let bundle = NSBundle(forClass:object_getClass(forObject))
  let path = bundle.URLForResource(named, withExtension: "json")!
  let data = NSData(contentsOfURL: path)!
  var error:NSError?
  let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
  assert(error == nil)
  return object as Dictionary<String, AnyObject>
}

func PollFixtureAttributes(forObject:AnyObject) -> Dictionary<String, AnyObject> {
  return JSONFixture("poll.attributes", forObject)
}

func PollFixture(forObject:AnyObject) -> Representor {
  return Representor { builder in
    builder.addLink("self", uri:"/polls/1/")
    builder.addLink("next", uri:"/polls/2/")

    builder.addAttribute("question", value:"Favourite programming language?")
    builder.addAttribute("published_at", value:"2014-11-11T08:40:51.620Z")
    builder.addAttribute("choices", value:[
      [
        "answer": "Swift",
        "votes": 2048,
      ], [
        "answer": "Python",
        "votes": 1024,
      ], [
        "answer": "Objective-C",
        "votes": 512,
      ], [
        "answer": "Ruby",
        "votes": 256,
      ],
    ])

    builder.addRepresentor("next") { builder in
      builder.addLink("self", uri:"/polls/2/")
      builder.addLink("next", uri:"/polls/3/")
      builder.addLink("previous", uri:"/polls/1/")
    }
  }
}
