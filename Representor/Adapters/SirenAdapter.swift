//
//  SirenAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

/// An extension to the Representor to add Siren support
/// It only supports siren links and properties
extension Representor {
    public init(siren:Dictionary<String, AnyObject>) {
        self.transitions = [:]
        self.representors = [:]
        self.metadata = [:]

        if let sirenLinks = siren["links"] as? [Dictionary<String, AnyObject>] {
            var links = Dictionary<String, String>()

            for link in sirenLinks {
                if let href = link["href"] as? String {
                    if let relations = link["rel"] as? [String] {
                        for relation in relations {
                            links[relation] = href
                        }
                    }
                }
            }

            self.links = links
        } else {
            self.links = [:]
        }

        if let properties = siren["properties"] as? Dictionary<String, AnyObject> {
            self.attributes = properties
        } else {
            self.attributes = [:]
        }
    }

    public func asSiren() -> Dictionary<String, AnyObject> {
        var representation = Dictionary<String, AnyObject>()

        if links.count > 0 {
            var links = [Dictionary<String, AnyObject>]()

            for (name, uri) in self.links {
                links.append(["rel": [name], "href": uri])
            }

            representation["links"] = links
        }

        representation["properties"] = attributes

        return representation
    }
}
