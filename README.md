# Hypermedia Resource in Swift

[![Build Status](http://img.shields.io/travis/the-hypermedia-project/hypermedia-resource-swift/master.svg?style=flat)](https://travis-ci.org/the-hypermedia-project/hypermedia-resource-swift)

Swift draft of the Hypermedia Resource library.

See [The Hypermedia Project](https://github.com/the-hypermedia-project/charter) for details.

## Usage

### Using the builder pattern to build a resource

```swift
import HypermediaResource

let resource = Resource { builder in
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
```

## License

Hypermedia Resource is released under the MIT license. See [LICENSE](LICENSE).