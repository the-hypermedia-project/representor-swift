# Hypermedia Resource in Swift

[![Build Status](http://img.shields.io/travis/the-hypermedia-project/hypermedia-resource-swift/master.svg?style=flat)](https://travis-ci.org/the-hypermedia-project/hypermedia-resource-swift)

Swift draft of the Hypermedia Resource library.

See [The Hypermedia Project](https://github.com/the-hypermedia-project/charter) for details.

## Usage

### Using the builder pattern to build a resource

```swift
import HypermediaResource

let resource = Resource { builder in
    builder.addLink("self", uri:"/notes/2/")
    builder.addLink("previous", uri:"/notes/1/")
    builder.addLink("next", uri:"/notes/3/")

    builder.addMetaData("title", "Customer Details")

    builder.addTransition("create", uri:"/notes/") { transitionBuilder in
        transitionBuilder.addAttribute("title")
        transitionBuilder.addAttribute("note")
    }
}
```

### Consuming a resource

```swift
if let create = resource.transitions["create"] {
    println("You can create with the URI: \(create.uri).")
}

if let uri = resource.links["next"] {
    println("The next resource can be found at: \(uri).")
}

if let uri = resource.links["previous"] {
    println("The previous resource can be found at: \(uri).")
}
```

## License

Hypermedia Resource is released under the MIT license. See [LICENSE](LICENSE).