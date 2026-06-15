import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum CachedAsyncImageLoader {
    static func data(from url: URL, cache: URLCache) async throws -> Data {
        let session: URLSession

        if cache === URLCache.shared {
            session = .shared
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = cache
            session = URLSession(configuration: configuration)
        }

        let (data, response) = try await session.data(from: url)
        try response.validateForImageLoading()
        return data
    }

    static func image(from data: Data, scale: CGFloat) async throws -> Image {
        try await Task.detached(priority: .userInitiated) {
#if os(macOS)
            guard let nsImage = NSImage(data: data) else {
                throw CachedAsyncImageLoadingError.invalidImageData
            }
            return Image(nsImage: nsImage)
#else
            guard let uiImage = UIImage(data: data, scale: scale) else {
                throw CachedAsyncImageLoadingError.invalidImageData
            }
            return Image(uiImage: uiImage)
#endif
        }.value
    }
}

enum CachedAsyncImageLoadingError: Error, Equatable {
    case invalidHTTPStatus(Int)
    case invalidImageData
}

extension URLResponse {
    func validateForImageLoading() throws {
        guard let response = self as? HTTPURLResponse else {
            return
        }

        guard 200..<300 ~= response.statusCode else {
            throw CachedAsyncImageLoadingError.invalidHTTPStatus(response.statusCode)
        }
    }
}
