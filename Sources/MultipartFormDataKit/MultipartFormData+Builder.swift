import Foundation



extension MultipartFormData {
    public typealias PartParam = (
        name: String,
        filename: String?,
        mimeType: MIMEType?,
        data: Data
    )



    public enum Builder {
        public static func build(
            with partParams: [PartParam],
            willSeparateBy uniqueBoundary: String
        ) throws -> BuildResult {
            switch TypedBuilder.build(with: partParams, willSeparateBy: uniqueBoundary) {
            case let .invalid(because: error):
                throw error

            case let .valid(result):
                return result
            }
        }
    }



    public enum TypedBuilder {
        public static func build(
            with partParams: [PartParam],
            willSeparateBy uniqueBoundary: String
        ) -> ValidationResult<BuildResult, BuildError> {
            var validParts = [MultipartFormData.Part]()
            for partParam in partParams {
                switch MultipartFormData.Part.create(
                    name: partParam.name,
                    filename: partParam.filename,
                    mimeType: partParam.mimeType,
                    data: partParam.data
                ) {
                case let .valid(part):
                    validParts.append(part)

                case let .invalid(because: reason):
                    return .invalid(because: .partCreationError(reason))
                }
            }

            let multipartFormData = MultipartFormData(
                uniqueAndValidLengthBoundary: uniqueBoundary,
                body: validParts
            )

            switch multipartFormData.asData() {
            case let .valid(data):
                return .valid(BuildResult(
                    contentType: multipartFormData.header.value,
                    body: data
                ))

            case let .invalid(because: reason):
                return .invalid(because: .dataTransformError(reason))
            }
        }
    }



    public enum BuildError: Error {
        case partCreationError(MultipartFormData.Part.CreationError)
        case dataTransformError(MultipartFormData.DataTransformError)
    }



    public struct BuildResult {
        public let contentType: String
        public let body: Data


        public init(contentType: String, body: Data) {
            self.contentType = contentType
            self.body = body
        }
    }
}



extension MultipartFormData.BuildResult: Equatable {
    public static func ==(
        lhs: MultipartFormData.BuildResult,
        rhs: MultipartFormData.BuildResult
    ) -> Bool {
        return lhs.contentType == rhs.contentType
            && lhs.body == rhs.body
    }
}
