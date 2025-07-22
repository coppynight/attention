import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    private init() {}

    func saveSessions(_ sessions: [FocusSession]) {
        // TODO: persist sessions to disk
    }

    func loadSessions() -> [FocusSession] {
        // TODO: load sessions from disk
        return []
    }
}
