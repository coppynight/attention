import Foundation

class FocusDetectionEngine {
    static let shared = FocusDetectionEngine()

    private let healthKitManager = HealthKitManager()
    private let motionManager = MotionManager()
    private let notificationTracker = NotificationTracker()

    func todayFocusMinutes() -> Int {
        let date = Date()
        let mindful = healthKitManager.getMindfulMinutes(date)
        let still = motionManager.getDeviceStillDuration(date)
        let interrupts = notificationTracker.getInterruptDuration(date)
        let duration = max(0, still * FocusAlgorithm.stillTimeWeight +
                            mindful * FocusAlgorithm.mindfulWeight -
                            interrupts * FocusAlgorithm.interruptPenalty)
        return Int(duration / 60)
    }
}
