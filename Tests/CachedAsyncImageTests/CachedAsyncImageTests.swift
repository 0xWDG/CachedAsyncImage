import XCTest
@testable import CachedAsyncImage

final class CachedAsyncImageTests: XCTestCase {
    func testSuccessfulHTTPResponseIsAccepted() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )

        XCTAssertNoThrow(try response.validateForImageLoading())
    }

    func testFailedHTTPResponseIsRejected() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/missing.png"))
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )
        )

        XCTAssertThrowsError(try response.validateForImageLoading()) { error in
            XCTAssertEqual(error as? CachedAsyncImageLoadingError, .invalidHTTPStatus(404))
        }
    }

    func testNonHTTPResponseIsAccepted() throws {
        let response = URLResponse(
            url: URL(fileURLWithPath: "/tmp/image.png"),
            mimeType: "image/png",
            expectedContentLength: 0,
            textEncodingName: nil
        )

        XCTAssertNoThrow(try response.validateForImageLoading())
    }

    func testInvalidImageDataIsRejected() async {
        do {
            _ = try await CachedAsyncImageLoader.image(from: Data("invalid".utf8), scale: 1)
            XCTFail("Expected invalid image data to be rejected")
        } catch {
            XCTAssertEqual(error as? CachedAsyncImageLoadingError, .invalidImageData)
        }
    }
}
