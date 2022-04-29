import Foundation



public protocol BoundaryGenerator {
    static func generate() -> String
}



public class RandomBoundaryGenerator: BoundaryGenerator {
    public static func generate() -> String {
			return String(format: "%08x%08x", UInt32.random(in: 0...UInt32.max), UInt32.random(in: 0...UInt32.max))
    }
}
