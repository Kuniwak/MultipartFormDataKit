import Foundation



extension MultipartFormData {
    public class Builder {
        public typealias Part = (
            name: String,
            filename: String?,
            mimeType: MIMEType?,
            data: Data
        )

        private let boundaryGenerator: BoundaryGenerator


        public init(generatingBoundaryBy boundaryGenerator: BoundaryGenerator) {
            self.boundaryGenerator = boundaryGenerator
        }



        public func build(
            with parts: [Part]
        ) -> ValidationResult<BuildResult, BuildError> {
            let uniqueBoundary = self.boundaryGenerator.generate()

            var validParts = [MultipartFormData.Part]()
            for part in parts {
                switch MultipartFormData.Part.create(
                    name: part.name,
                    filename: part.filename,
                    mimeType: part.mimeType,
                    data: part.data
                ) {
                case let .valid(validPart):
                    validParts.append(validPart)

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



        public enum BuildError {
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
}



extension MultipartFormData.Builder.BuildResult: Equatable {
    public static func ==(lhs: MultipartFormData.Builder.BuildResult, rhs: MultipartFormData.Builder.BuildResult) -> Bool {
        return lhs.contentType == rhs.contentType
            && lhs.body == rhs.body
    }
}
