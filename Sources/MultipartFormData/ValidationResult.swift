public enum ValidationResult<Content, FailureReason> {
    case valid(Content)
    case invalid(because: FailureReason)


    public var content: Content? {
        switch self {
        case let .valid(content):
            return content

        case .invalid:
            return nil
        }
    }


    public var reason: FailureReason? {
        switch self {
        case .valid:
            return nil
        case let .invalid(because: reason):
            return reason
        }
    }
}
