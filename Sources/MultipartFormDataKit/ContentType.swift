import Foundation



// RFC 7528 multipart/form-data
// 4.4.  Content-Type Header Field for Each Part
public struct ContentType {
    // Each part MAY have an (optional) "Content-Type" header field, which
    // defaults to "text/plain".  If the contents of a file are to be sent,
    // the file data SHOULD be labeled with an appropriate media type, if
    // known, or "application/octet-stream".
    public var value: MIMEType
    public var parameters: [Parameter]


    public init(representing value: MIMEType, with parameters: [Parameter] = []) {
        self.value = value
        self.parameters = parameters
    }


    public func asHeader() -> Header {
        return .from(
            mimeType: self.value,
            parameters: self.parameters
        )
    }



    public func asData() -> ValidationResult<Data, DataTransformError> {
        let headerText = self.asHeader().text
        guard let data = headerText.data(using: .utf8) else {
            return .invalid(because: .cannotEncodeAsUTF8(debugInfo: headerText))
        }

        return .valid(data)
    }



    public struct Header /* : CustomStringConvertible */ {
        public var name: String {
            return "Content-Type"
        }
        public var value: String


        public var text: String {
            return "\(self.name): \(self.value)"
        }


        public init(representing value: String) {
            self.value = value
        }


        public static func from(mimeType: MIMEType, parameters: [Parameter]) -> Header {
            let parametersPart = parameters
                .map { "; \($0.text)" }
                .joined(separator: "")

            return Header(representing: "\(mimeType.text)\(parametersPart)")
        }
    }



    public struct Parameter /* : CustomStringConvertible */ {
        public var attribute: String
        public var value: String

        public var text: String {
            return "\(self.attribute)=\"\(self.value)\""
        }
    }



    public enum DataTransformError: Error {
        case cannotEncodeAsUTF8(debugInfo: String)
    }
}