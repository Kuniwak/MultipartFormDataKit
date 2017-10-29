import XCTest
import MultipartFormDataKit


class ContentDispositionTests: XCTestCase {
    private struct TestCase {
        let contentDisposition: ContentDisposition
        let expected: String
    }


    func testAsHeader() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                contentDisposition: ContentDisposition(
                    name: Name(asPercentEncoded: "name"),
                    filename: nil
                ),
                expected: "Content-Disposition: form-data; name=\"name\""
            ),
            #line: TestCase(
                contentDisposition: ContentDisposition(
                    name: Name(asPercentEncoded: "name"),
                    filename: Filename(asPercentEncoded: "filename")
                ),
                expected: "Content-Disposition: form-data; name=\"name\"; filename=\"filename\""
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = testCase.contentDisposition.asHeader()
            let expected = testCase.expected

            XCTAssertEqual(actual.text, expected)
        }
    }


    static var allTests: [(String, (ContentDispositionTests) -> () throws -> Void)] {
        return [
            ("testAsHeader", self.testAsHeader),
        ]
    }
}

