import XCTest
@testable import MultipartFormDataTests

XCTMain([
    testCase(MultipartFormDataTests.allTests),
    testCase(ContentDispositionTests.allTests),
    testCase(ContentTypeTests.allTests),
    testCase(FilenameTests.allTests),
    testCase(NameTests.allTests),
    testCase(MultipartFormDataBuilderTests.allTests),
])
