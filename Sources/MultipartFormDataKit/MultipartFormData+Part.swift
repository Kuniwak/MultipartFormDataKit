import Foundation



extension MultipartFormData {
    public struct Part {
        public let contentDisposition: ContentDisposition
        public let contentType: ContentType?
        public let content: Data


        public init(
            contentDisposition: ContentDisposition,
            contentType: ContentType?,
            content: Data
        ) {
            self.contentDisposition = contentDisposition
            self.contentType = contentType
            self.content = content
        }


        // RFC 2046 Multipurpose Internet Mail Extensions (MIME) Part Two: Media Types
        // 5.1.1.  Common Syntax
        //
        // ...
        //
        // This Content-Type value indicates that the content consists of one or
        // more parts, each with a structure that is syntactically identical to
        // an RFC 822 message, except that the header area is allowed to be
        // completely empty, and that the parts are each preceded by the line
        //
        //     --gc0pJq0M:08jU534c0p
        //
        // The boundary delimiter MUST occur at the beginning of a line, i.e.,
        // following a CRLF, and the initial CRLF is considered to be attached
        // to the boundary delimiter line rather than part of the preceding
        // part.  The boundary may be followed by zero or more characters of
        // linear whitespace. It is then terminated by either another CRLF and
        // the header fields for the next part, or by two CRLFs, in which case
        // there are no header fields for the next part.  If no Content-Type
        // field is present it is assumed to be "message/rfc822" in a
        // "multipart/digest" and "text/plain" otherwise.
        public func write(to data: inout Data) -> DataTransformError? {
            guard let contentType = self.contentType else {
                switch self.contentDisposition.asData() {
                case let .valid(contentDispositionData):
                    data.append(contentDispositionData)
                    data.append(CRLF)
                    data.append(CRLF)
                    data.append(self.content)
                    data.append(CRLF)
                    return nil

                case let .invalid(because: error):
                    return .contentDispositionError(error)
                }
            }

            switch (
                self.contentDisposition.asData(),
                contentType.asData()
            ) {
            case let (.valid(contentDispositionData), .valid(contentTypeData)):
                data.append(contentDispositionData)
                data.append(CRLF)
                data.append(contentTypeData)
                data.append(CRLF)
                data.append(CRLF)
                data.append(self.content)
                data.append(CRLF)
                return nil

            case let (.invalid(because: error), _):
                return .contentDispositionError(error)

            case let (_, .invalid(because: error)):
                return .contentTypeError(error)
            }
        }



        public static func create(
            name: String,
            filename: String?,
            mimeType: MIMEType?,
            data: Data
        ) -> ValidationResult<Part, CreationError> {
            guard let filename = filename else {
                switch Name.create(by: name) {
                case let .valid(name):
                    return .valid(
                        MultipartFormData.Part(
                            contentDisposition: ContentDisposition(
                                name: name,
                                filename: nil
                            ),
                            contentType: mimeType.map { mimeType in
                                ContentType(representing: mimeType)
                            },
                            content: data
                        )
                    )

                case let .invalid(because: error):
                    return .invalid(because: .invalidName(error))
                }
            }

            switch (
                Name.create(by: name),
                Filename.create(by: filename)
            ) {
            case let (.valid(name), .valid(filename)):
                return .valid(MultipartFormData.Part(
                    contentDisposition: ContentDisposition(
                        name: name,
                        filename: filename
                    ),
                    contentType: mimeType.map { mimeType in
                        ContentType(representing: mimeType)
                    },
                    content: data
                ))

            case let (.invalid(because: reason), _):
                return .invalid(because: .invalidName(reason))

            case let (_, .invalid(because: reason)):
                return .invalid(because: .invalidFilename(reason))
            }
        }



        public enum CreationError: Error {
            case invalidName(Name.FailureReason)
            case invalidFilename(Filename.FailureReason)
        }
    }
}