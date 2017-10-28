import XCTest
@testable import MultipartFormData

class MultipartFormDataTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MultipartFormData().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
