import XCTest
import MultipartFormData


class MultipartFormDataBuilderTests: XCTestCase {
    func testBuild() {
        let builder = MultipartFormData.Builder(
            generatingBoundaryBy: ConstantBoundaryGenerator(willReturn: "boundary")
        )

        let result = builder.build(with: [
            (
                name: "example1",
                filename: nil,
                mimeType: nil,
                data: "Hello, World!".data(using: .utf8)!
            ),
            (
                name: "example2",
                filename: "example.txt",
                mimeType: MIMEType.textPlain,
                data: "EXAMPLE_TXT".data(using: .utf8)!
            ),
        ])

        let expected = [
            "--boundary",
            "Content-Disposition: form-data; name=\"example1\"",
            "",
            "Hello, World!",
            "--boundary",
            "Content-Disposition: form-data; name=\"example2\"; filename=\"example.txt\"",
            "Content-Type: text/plain",
            "",
            "EXAMPLE_TXT",
            "--boundary--",
        ].joined(separator: "\r\n") + "\r\n"


        switch result {
        case let .invalid(because: error):
            XCTFail("\(error)")

        case let .valid(multipartFormData):
            XCTAssertEqual(
                multipartFormData.contentType,
                "multipart/form-data; boundary=\"boundary\""
            )
            XCTAssertEqual(
                String(data: multipartFormData.body, encoding: .utf8)!,
                expected
            )
        }
    }


    static var allTests: [(String, (MultipartFormDataBuilderTests) -> () throws -> Void)] {
        return [
            ("testBuild", self.testBuild),
        ]
    }
}

