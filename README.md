MultipartFormDataKit
====================

![Swift 5.6 compatible](https://img.shields.io/badge/Swift%20version-5.6-green.svg)
![Swift Package Manager and Carthage and CocoaPods compatible](https://img.shields.io/badge/SPM%20%7C%20Carthage%20%7C%20CocoaPods-compatible-green.svg)
[![v2.0.0](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/Kuniwak/MultipartFormData/releases)
[![Build Status](https://www.bitrise.io/app/8c05b2758bfbf0d8/status.svg?token=vqY7qlmU6qeCPZ17EX7vRA&branch=master)](https://www.bitrise.io/app/8c05b2758bfbf0d8)


`multipart/form-data` for Swift.


Basic Usage
-----------

```swift
let multipartFormData = try MultipartFormData.Builder.build(
    with: [
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
    ],
    willSeparateBy: RandomBoundaryGenerator.generate()
)

var request = URLRequest(url: URL(string: "http://example.com")!)
request.httpMethod = "POST"
request.setValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
request.httpBody = multipartFormData.body

let task = URLSession.shared.dataTask(with: request)
task.resume()
```



Advanced Usage
--------------

```swift
let multipartFormData = MultipartFormData(
    uniqueAndValidLengthBoundary: "boundary",
    body: [
        MultipartFormData.Part(
            contentDisposition: ContentDisposition(
                name: Name(asPercentEncoded: "field%201"),
                filename: nil
            ),
            contentType: nil,
            content: "value1".data(using: .utf8)!
        ),
        MultipartFormData.Part(
            contentDisposition: ContentDisposition(
                name: Name(asPercentEncoded: "field%202"),
                filename: Filename(asPercentEncoded: "example.txt")
            ),
            contentType: ContentType(representing: .textPlain),
            content: "value2".data(using: .utf8)!
        ),
    ]
)

print(multipartFormData.header.name)
// Content-Type

print(multipartFormData.header.value)
// multipart/form-data; boundary="boundary"

switch multipartFormData.asData() {
case let .valid(data):
    print(String(data: data, encoding: .utf8))

    // --boundary
    // Content-Disposition: form-data; name="field1"
    // 
    // value1
    // --boundary
    // Content-Disposition: form-data; name="filed2"; filename="example.txt"
    // Content-Type: text/plain
    // 
    // value2
    // --boundary--

case let .invalid(error):
    print(error)
}
```


License
-------

MIT
