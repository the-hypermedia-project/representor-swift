# Representor in Swift

[![Build Status](http://img.shields.io/travis/the-hypermedia-project/representor-swift/master.svg?style=flat)](https://travis-ci.org/the-hypermedia-project/representor-swift)

Swift library for building and consuming Hypermedia messages. See [The Hypermedia Project Charter](https://github.com/the-hypermedia-project/charter) for details.

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

### Adapters

The representor includes adapters to convert between other hypermedia types.

#### NSHTTPURLResponse

You can initialise a representor using a `NSHTTPURLResponse` and the body (`NSData`). It will use the content-type from the response and deserialise the body payload into a format. For unsupported/unknown types, nil will returned.

```swift
let representor = Representor.deserialize(response, body: body)
```

You can register your own, or overide an existing HTTP deserializer for a
specific content type.

```swift
Representor.HTTPDeserializers["application/json"] = { response, body in
  return Representor(...)
}
```

##### Supported Media Types

- [HAL](http://stateless.co/hal_specification.html) JSON (application/hal+json)
- [Siren](https://github.com/kevinswiber/siren) JSON (application/vnd.siren+json)
- [JSON](http://www.json.org) + [Link Headers](http://tools.ietf.org/html/rfc5988) (application/json)

#### HAL

You can explicitly convert to and from a [HAL](http://stateless.co/hal_specification.html) representation using the following.

```swift
let representor = Representor(hal:representation)
```

```swift
let representation = representor.asHAL()
```

#### Siren

Conversion to and from a [Siren](https://github.com/kevinswiber/siren) representation can also be done using the following.

```swift
let representor = Representor(siren:representation)
```

```swift
let representation = representor.asSiren()
```

## License

Representor is released under the MIT license. See [LICENSE](LICENSE).

