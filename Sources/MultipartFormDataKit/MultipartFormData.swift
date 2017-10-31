import Foundation



// RFC 7528 multipart/form-data
// 4.  Definition of multipart/form-data
//
// The media type multipart/form-data follows the model of multipart
// MIME data streams as specified in Section 5.1 of [RFC2046]; changes
// are noted in this document.
//
// A multipart/form-data body contains a series of parts separated by a
// boundary.
public struct MultipartFormData {
    public var header: ContentType.Header {
        return .from(
            mimeType: .multipartFormData,
            parameters: [
                ContentType.Parameter(
                    attribute: "boundary",
                    value: self.uniqueAndValidLengthBoundary
                ),
            ]
        )
    }


    // 4.1.  "Boundary" Parameter of multipart/form-data
    //
    // As with other multipart types, the parts are delimited with a
    // boundary delimiter, constructed using CRLF, "--", and the value of
    // the "boundary" parameter.  The boundary is supplied as a "boundary"
    // parameter to the multipart/form-data type.  As noted in Section 5.1
    // of [RFC2046], the boundary delimiter MUST NOT appear inside any of
    // the encapsulated parts, and it is often necessary to enclose the
    // "boundary" parameter values in quotes in the Content-Type header
    // field.
    public let uniqueAndValidLengthBoundary: String
    public let body: [Part]


    // Boundary delimiters must not appear within the encapsulated material,
    // and must be no longer than 70 characters, not counting the two
    // leading hyphens.
    public static let maxLengthOfBoundary = 70


    public init(
        uniqueAndValidLengthBoundary: String,
        body: [Part]
    ) {
        self.uniqueAndValidLengthBoundary = uniqueAndValidLengthBoundary
        self.body = body
    }


    public func asData() -> ValidationResult<Data, DataTransformError> {
        var data = Data()
        guard let boundaryData = self.uniqueAndValidLengthBoundary.data(using: .utf8) else {
            return .invalid(because: .boundaryError(debugInfo: self.uniqueAndValidLengthBoundary))
        }

        for part in self.body {
            data.append(DASH)
            data.append(boundaryData)
            data.append(CRLF)
            if let error = part.write(to: &data) {
                return .invalid(because: error)
            }
        }

        data.append(DASH)
        data.append(boundaryData)
        data.append(DASH)
        data.append(CRLF)

        return .valid(data)
    }



    public enum DataTransformError: Error {
        case contentDispositionError(ContentDisposition.DataTransformError)
        case contentTypeError(ContentType.DataTransformError)
        case boundaryError(debugInfo: String)
    }
}
