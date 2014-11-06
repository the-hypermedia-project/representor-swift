# Representor in Swift

[![Build Status](http://img.shields.io/travis/the-hypermedia-project/hypermedia-resource-swift/master.svg?style=flat)](https://travis-ci.org/the-hypermedia-project/hypermedia-resource-swift)

Swift draft of the Representor library.

See [The Hypermedia Project](https://github.com/the-hypermedia-project/charter) for details.

## Usage

### Using the builder pattern to build a representor

```swift
import Representor

let representor = Representor { builder in
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

### Consuming a representor

```swift
if let create = representor.transitions["create"] {
    println("You can create with the URI: \(create.uri).")
}

if let uri = representor.links["next"] {
    println("The next representor can be found at: \(uri).")
}

if let uri = representor.links["previous"] {
    println("The previous representor can be found at: \(uri).")
}
```

## License

Representor is released under the MIT license. See [LICENSE](LICENSE).