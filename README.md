# CachedAsyncImage

CachedAsyncImage is a Swift Package for asynchronously loading images from the web and caching them.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FCachedAsyncImage%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/CachedAsyncImage)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FCachedAsyncImage%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/CachedAsyncImage)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/CachedAsyncImage)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/CachedAsyncImage.git", .branch("main")),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "CachedAsyncImage", package: "CachedAsyncImage"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/CachedAsyncImage`) and click **Next**.
3. Click **Finish**.

## Usage

`CachedAsyncImage` has the exact same API and behavior as `AsyncImage`, so you just have to change this:

```swift
AsyncImage(url: logoURL)
```

to this:

```swift
CachedAsyncImage(url: logoURL)
```

example:

```swift
import SwiftUI
import CachedAsyncImage

struct ContentView: View {
    var body: some View {
        VStack {
            CachedAsyncImage(
                url: URL(
                    string: "https://wesleydegroot.nl/assets/avatar/avatar.webp"
                )
            ) { image in
                image
                    .resizable()
                    .frame(width: 250, height: 250)
            } placeholder: {
                ProgressView()
            }
        }
        .padding()
    }
}
```

In addition to `AsyncImage` initializers, you have the possibilities to specify the cache you want to use (by default `URLCache.shared` is used), and to use `URLRequest` instead of `URL`:

```swift
CachedAsyncImage(urlRequest: logoURLRequest, urlCache: .imageCache)
```

```swift
// URLCache+imageCache.swift

extension URLCache {

    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
```

Remember when setting the cache the response (in this case our image) must be no larger than about 5% of the disk cache (See [this discussion](https://developer.apple.com/documentation/foundation/nsurlsessiondatadelegate/1411612-urlsession#discussion)).

## Contact

We can get in touch via [Twitter/X](https://twitter.com/0xWDG), [Discord](https://discordapp.com/users/918438083861573692), [Mastodon](https://iosdev.space/@0xWDG), [Email](mailto:email+oss@wesleydegroot.nl), [Website](https://wesleydegroot.nl).
