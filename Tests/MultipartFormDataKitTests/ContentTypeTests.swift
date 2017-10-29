import XCTest
@testable import MultipartFormDataKit


class ContentTypeTests: XCTestCase {
    private struct TestCase {
        let contentType: ContentType
        let expected: String
    }


    func testAsHeader() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                contentType: ContentType(
                    representing: .textPlain
                ),
                expected: "Content-Type: text/plain"
            ),
            #line: TestCase(
                contentType: ContentType(
                    representing: .textPlain,
                    with: [
                        ContentType.Parameter(attribute: "charset", value: "UTF-8"),
                    ]
                ),
                expected: "Content-Type: text/plain; charset=\"UTF-8\""
            ),
            #line: TestCase(
                contentType: ContentType(
                    representing: .textPlain,
                    with: [
                        ContentType.Parameter(attribute: "attr1", value: "value1"),
                        ContentType.Parameter(attribute: "attr2", value: "value2"),
                    ]
                ),
                expected: "Content-Type: text/plain; attr1=\"value1\"; attr2=\"value2\""
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = testCase.contentType.asHeader()
            let expected = testCase.expected

            XCTAssertEqual(actual.text, expected)
        }
    }


    static var allTests: [(String, (ContentTypeTests) -> () throws -> Void)] {
        return [
            ("testAsHeader", self.testAsHeader),
        ]
    }
}
