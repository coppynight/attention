import Foundation

struct FocusSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let dataSources: [String]
}
