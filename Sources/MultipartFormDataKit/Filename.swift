import Foundation


// RFC 7528 multipart/form-data
// 4.2.  Content-Disposition Header Field for Each Part
//
// ...
//
// If a "filename" parameter is supplied, the requirements of
// Section 2.3 of [RFC2183] for the "receiving MUA" (i.e., the receiving
// Mail User Agent) apply to receivers of multipart/form-data as well:
// do not use the file name blindly, check and possibly change to match
// local file system conventions if applicable, and do not use directory
// path information that may be present.
// In most multipart types, the MIME header fields in each part are
// restricted to US-ASCII; for compatibility with those systems, file
// names normally visible to users MAY be encoded using the percent-
// encoding method in Section 2, following how a "file:" URI
// [URI-SCHEME] might be encoded.
//
// ...
public struct Filename {
    public let percentEncodedString: String


    public init(asPercentEncoded percentEncodedString: String) {
        self.percentEncodedString = percentEncodedString
    }


    public static func create(by filename: String) -> ValidationResult<Filename, FailureReason> {
        guard let percentEncodedString = filename.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return .invalid(because: .cannotPercentEncode(debugInfo: filename))
        }

        return .valid(Filename(asPercentEncoded: percentEncodedString))
    }


    public enum FailureReason: Error {
        case cannotPercentEncode(debugInfo: String)
    }
}
