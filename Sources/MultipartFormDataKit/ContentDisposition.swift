import Foundation



// RFC 7528 multipart/form-data
// 4.2.  Content-Disposition Header Field for Each Part
public struct ContentDisposition {
    // Each part MUST contain a Content-Disposition header field [RFC2183]
    // where the disposition type is "form-data".
    public var value: String {
        return "form-data"
    }

    // Each part MUST contain a Content-Disposition header field [RFC2183]
    // where the disposition type is "form-data".  The Content-Disposition
    // header field MUST also contain an additional parameter of "name"; the
    // value of the "name" parameter is the original field name from the
    // form (possibly encoded; see Section 5.1).  For example, a part might
    // contain a header field such as the following, with the body of the
    // part containing the form data of the "user" field:
    //
    //     Content-Disposition: form-data; name="user"
    //
    public var name: Name

    // For form data that represents the content of a file, a name for the
    // file SHOULD be supplied as well, by using a "filename" parameter of
    // the Content-Disposition header field.  The file name isn't mandatory
    // for cases where the file name isn't available or is meaningless or
    // private; this might result, for example, when selection or drag-and-
    // drop is used or when the form data content is streamed directly from
    // a device.
    public var filename: Filename?


    public init(name: Name, filename: Filename?) {
        self.name = name
        self.filename = filename
    }


    public func asHeader() -> Header {
        var parameters: [Parameter] = [
            Parameter(
                attribute: "name",
                value: self.name.percentEncodedString
            ),
        ]

        if let filename = self.filename {
            parameters.append(Parameter(
                attribute: "filename",
                value: filename.percentEncodedString
            ))
        }

        return .from(value: self.value, parameters: parameters)
    }


    public func asData() -> ValidationResult<Data, DataTransformError> {
        let headerText = self.asHeader().text
        guard let data = headerText.data(using: .utf8) else {
            return .invalid(because: .cannotEncodeAsUTF8(debugInfo: headerText))
        }

        return .valid(data)
    }



    public struct Header /* : CustomStringConvertible */  {
        public var name: String {
            return "Content-Disposition"
        }
        public let value: String


        public var text: String {
            return "\(self.name): \(self.value)"
        }


        public init(representing value: String) {
            self.value = value
        }


        public static func from(value: String, parameters: [Parameter]) -> Header {
            let parametersPart = parameters
                .map { "; \($0.text)" }
                .joined(separator: "")

            return Header(representing: "\(value)\(parametersPart)")
        }
    }



    public struct Parameter /* : CustomStringConvertible */ {
        public let attribute: String
        public let value: String


        public var text: String {
            return "\(self.attribute)=\"\(self.value)\""
        }
    }



    public enum DataTransformError: Error {
        case cannotEncodeAsUTF8(debugInfo: String)
    }
}
