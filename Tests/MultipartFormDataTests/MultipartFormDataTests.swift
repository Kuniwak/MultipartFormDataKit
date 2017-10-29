import XCTest
@testable import MultipartFormData

class MultipartFormDataTests: XCTestCase {
    private struct TestCase {
        let multipartFormData: MultipartFormData
        let expected: String
    }


    func testAsData() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                multipartFormData: MultipartFormData(
                    uniqueAndValidLengthBoundary: "boundary",
                    body: [
                        MultipartFormData.Part(
                            contentDisposition: ContentDisposition(
                                name: Name(asPercentEncoded: "field1"),
                                filename: nil
                            ),
                            contentType: nil,
                            content: "value1".data(using: .utf8)!
                        ),
                        MultipartFormData.Part(
                            contentDisposition: ContentDisposition(
                                name: Name(asPercentEncoded: "field2"),
                                filename: Filename(asPercentEncoded: "example.txt")
                            ),
                            contentType: ContentType(representing: .textPlain),
                            content: "value2".data(using: .utf8)!
                        ),
                    ]
                ),
                expected: [
                    "--boundary",
                    "Content-Disposition: form-data; name=\"field1\"",
                    "",
                    "value1",
                    "--boundary",
                    "Content-Disposition: form-data; name=\"field2\"; filename=\"example.txt\"",
                    "Content-Type: text/plain",
                    "",
                    "value2",
                    "--boundary--",
                ].joined(separator: "\r\n") + "\r\n"
            )
        ]


        testCases.forEach { (line, testCase) in
            let actual = String(data: testCase.multipartFormData.asData().content!, encoding: .utf8)
            let expected = testCase.expected

            XCTAssertEqual(actual, expected)
        }
    }


    static var allTests = [
        ("testAsData", testAsData),
    ]
}
