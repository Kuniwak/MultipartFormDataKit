import XCTest
@testable import MultipartFormDataKit



class NameTests: XCTestCase {
    private struct TestCase {
        let filename: String
        let expected: Name
    }


    func testInit() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                filename: "abc123ABC",
                expected: Name(asPercentEncoded: "abc123ABC")
            ),
            #line: TestCase(
                filename: "=;\"",
                expected: Name(asPercentEncoded: "=%3B%22")
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = Name.create(by: testCase.filename)
            let expected = testCase.expected

            XCTAssertEqual(actual.content?.percentEncodedString, expected.percentEncodedString)
        }
    }


    static var allTests: [(String, (NameTests) -> () throws -> Void)] {
        return [
            ("testInit", self.testInit)
        ]
    }
}
