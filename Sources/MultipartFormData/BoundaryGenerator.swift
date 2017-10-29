import Foundation



public protocol BoundaryGenerator {
    func generate() -> String
}



public class ConstantBoundaryGenerator: BoundaryGenerator {
    private let boundary: String


    public init(willReturn boundary: String) {
        self.boundary = boundary
    }


    public func generate() -> String {
        return self.boundary
    }
}



public class RandomBoundaryGenerator: BoundaryGenerator {
    public func generate() -> String {
        return String(format: "%08x%08x", arc4random(), arc4random())
    }
}