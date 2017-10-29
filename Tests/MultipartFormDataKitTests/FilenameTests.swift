import XCTest
@testable import MultipartFormDataKit



class FilenameTests: XCTestCase {
    private struct TestCase {
        let filename: String
        let expected: Filename
    }


    func testInit() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                filename: "abc123ABC",
                expected: Filename(asPercentEncoded: "abc123ABC")
            ),
            #line: TestCase(
                filename: "example.jpg",
                expected: Filename(asPercentEncoded: "example.jpg")
            ),
            #line: TestCase(
                filename: "=;\"",
                expected: Filename(asPercentEncoded: "=%3B%22")
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = Filename.create(by: testCase.filename)
            let expected = testCase.expected

            XCTAssertEqual(actual.content?.percentEncodedString, expected.percentEncodedString)
        }
    }


    static var allTests: [(String, (FilenameTests) -> () throws -> Void)] {
        return [
            ("testInit", self.testInit)
        ]
    }
}
