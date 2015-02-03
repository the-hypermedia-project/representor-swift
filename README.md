# Representor in Swift

[![Build Status](http://img.shields.io/travis/the-hypermedia-project/representor-swift/master.svg?style=flat)](https://travis-ci.org/the-hypermedia-project/representor-swift)

Swift library for building and consuming Hypermedia messages. See [The Hypermedia Project Charter](https://github.com/the-hypermedia-project/charter) for details.

## Installation

Installation with CocoaPods is recommended using CocoaPods 0.36.

```ruby
pod 'Representor'
```

### Sub-projects

Alternatively, you can clone Representor via git or as a submodule and
include Representor.xcodeproj inside your project and add
Representor.framework as a target dependency.

## Usage

### Using the builder pattern to build a representor

```swift
import Representor

let representor = Representor<HTTPTransition> { builder in
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

### Adapters

The representor includes adapters to convert between other hypermedia types.

#### NSHTTPURLResponse

You can initialise a representor using a `NSHTTPURLResponse` and the body (`NSData`). It will use the content-type from the response and deserialise the body payload into a format. For unsupported/unknown types, nil will returned.

```swift
let representor = HTTPDeserialization.deserialize(response, body: body)
```

You can register your own, or overide an existing HTTP deserializer for a
specific content type.

```swift
HTTPDeserialization.deserializers["application/json"] = { response, body in
  return Representor(...)
}
```

##### Supported Media Types

- [HAL](http://stateless.co/hal_specification.html) JSON (application/hal+json)
- [Siren](https://github.com/kevinswiber/siren) JSON (application/vnd.siren+json)

#### HAL

You can explicitly convert to and from a [HAL](http://stateless.co/hal_specification.html) representation using the following.

```swift
let representor = deserializeHAL(representation)
```

```swift
let representation = serializeHAL(representor)
```

#### Siren

Conversion to and from a [Siren](https://github.com/kevinswiber/siren) representation can also be done using the following.

```swift
let representor = deserializeSiren(representation)
```

```swift
let representation = serializeSiren(representor)
```

## License

Representor is released under the MIT license. See [LICENSE](LICENSE).

