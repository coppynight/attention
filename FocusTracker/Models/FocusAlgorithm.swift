import Foundation

struct FocusAlgorithm {
    static let stillTimeWeight: Double = 0.8
    static let mindfulWeight: Double = 1.0
    static let interruptPenalty: Double = 2.0
    static let minimumFocusDuration: TimeInterval = 1800
}
