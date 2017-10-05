//
//  Utils.swift
//  Representor
//
//  Created by Kyle Fuller on 18/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import Representor

func fixture(_ named:String, forObject:AnyObject) -> Data {
  let bundle = Bundle(for:object_getClass(forObject)!)
  let path = bundle.url(forResource: named, withExtension: "json")!
  let data = try! Data(contentsOf: path)
  return data
}

func JSONFixture(_ named: String, forObject: AnyObject) -> [String: Any] {
  let data = fixture(named, forObject: forObject)
  let object = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
  return object as! [String: Any]
}

func PollFixtureAttributes(_ forObject: AnyObject) -> [String: Any] {
  return JSONFixture("poll.attributes", forObject: forObject)
}

func PollFixture(_ forObject:AnyObject) -> Representor<HTTPTransition> {
  return Representor { builder in
    builder.addTransition("self", uri:"/polls/1/")
    builder.addTransition("next", uri:"/polls/2/")

    builder.addAttribute("question", value: "Favourite programming language?" as AnyObject)
    builder.addAttribute("published_at", value: "2014-11-11T08:40:51.620Z" as AnyObject)
    builder.addAttribute("choices", value: [
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
    ] as AnyObject)

    builder.addRepresentor("next") { builder in
      builder.addTransition("self", uri:"/polls/2/")
      builder.addTransition("next", uri:"/polls/3/")
      builder.addTransition("previous", uri:"/polls/1/")
    }
  }
}
