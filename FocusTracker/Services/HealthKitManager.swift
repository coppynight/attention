import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()

    func requestAuthorization() async throws {
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        try await healthStore.requestAuthorization(toShare: [], read: [mindfulType])
    }

    func getMindfulMinutes(_ date: Date) -> TimeInterval {
        // TODO: implement HealthKit query
        return 0
    }
}
