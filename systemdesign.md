# 专注时长测算App - 系统设计方案

## 系统架构概览

```
┌─────────────────────┐
│    iOS App Layer    │
├─────────────────────┤
│   Business Logic    │
├─────────────────────┤
│   Data Collection   │
├─────────────────────┤
│   iOS System APIs   │
└─────────────────────┘
```

## 核心模块设计

### 1. 专注检测引擎

#### 1.1 多源数据融合
```swift
class FocusDetectionEngine {
    // 数据源管理器
    private let healthKitManager: HealthKitManager
    private let motionManager: MotionManager
    private let notificationTracker: NotificationTracker
    private let screenStateMonitor: ScreenStateMonitor
    
    // 专注时间计算
    func calculateFocusTime(for date: Date) -> TimeInterval {
        let mindfulMinutes = healthKitManager.getMindfulMinutes(date)
        let stillTime = motionManager.getDeviceStillDuration(date)
        let interruptTime = notificationTracker.getInterruptDuration(date)
        
        return max(0, stillTime + mindfulMinutes - interruptTime)
    }
}
```

#### 1.2 算法权重配置
```swift
struct FocusAlgorithm {
    static let stillTimeWeight: Double = 0.8      // 设备静止权重
    static let mindfulWeight: Double = 1.0        // 正念训练权重
    static let interruptPenalty: Double = 2.0     // 打断惩罚系数
    static let minimumFocusDuration: TimeInterval = 1800  // 30分钟最小专注
}
```

### 2. 数据收集模块

#### 2.1 Apple健康数据集成
```swift
class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
        try await healthStore.requestAuthorization(toShare: [], read: [mindfulType])
    }
    
    func getMindfulMinutes(_ date: Date) -> TimeInterval {
        // 获取指定日期的正念训练时长
    }
}
```

#### 2.2 设备运动状态检测
```swift
class MotionManager {
    private let activityManager = CMMotionActivityManager()
    
    func getDeviceStillDuration(_ date: Date) -> TimeInterval {
        // 检测设备静止时长（手机放在桌上）
        // 使用CMMotionActivityManager查询历史活动
    }
}
```

#### 2.3 通知打断统计
```swift
class NotificationTracker {
    func getInterruptDuration(_ date: Date) -> TimeInterval {
        // 统计通知频率，估算打断时长
        // 每收到一次通知记为2分钟打断
    }
}
```

#### 2.4 屏幕状态监控
```swift
class ScreenStateMonitor {
    // 监听屏幕开启/关闭事件
    // 结合时间计算可能的专注时段
}
```

### 3. 数据存储设计

#### 3.1 数据模型
```swift
struct FocusSession {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let startTime: Date
    let endTime: Date
    let confidence: Double  // 检测置信度
    let dataSources: [String]  // 数据来源
}

struct DailyFocus {
    let date: Date
    let totalFocusTime: TimeInterval
    let pickupCount: Int
    let longestSession: TimeInterval
    let dataQuality: Double
}
```

#### 3.2 本地存储
```swift
class LocalStorage {
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default
    
    func saveFocusSession(_ session: FocusSession) {
        // 使用JSON存储到Documents目录
    }
    
    func getDailyFocus(_ date: Date) -> DailyFocus? {
        // 从本地存储读取每日专注数据
    }
}
```

### 4. iOS小组件设计

#### 4.1 WidgetKit实现
```swift
struct FocusWidget: Widget {
    let kind: String = "FocusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusProvider()) { entry in
            FocusWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FocusProvider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<FocusEntry>) -> Void) {
        let currentFocusTime = FocusDetectionEngine.shared.getTodayFocusTime()
        let entry = FocusEntry(date: Date(), focusTime: currentFocusTime)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}
```

#### 4.2 小组件UI设计
```swift
struct FocusWidgetView: View {
    var entry: FocusProvider.Entry
    
    var body: some View {
        VStack {
            Text("今日专注")
                .font(.caption)
            Text(formattedTime(entry.focusTime))
                .font(.title2.bold())
            Text("比昨天多15分钟")
                .font(.caption2)
                .foregroundColor(.green)
        }
    }
}
```

### 5. 推送通知系统

#### 5.1 推送策略
```swift
class NotificationManager {
    func scheduleDailySummary() {
        let content = UNMutableNotificationContent()
        content.title = "昨日专注总结"
        content.body = "昨日专注2小时15分，比周一多了30分钟！"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailySummary", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
```

### 6. 隐私与安全设计

#### 6.1 数据权限管理
```swift
class PrivacyManager {
    static let shared = PrivacyManager()
    
    func requestAllPermissions() async throws {
        try await requestHealthKitPermission()
        try await requestNotificationPermission()
        try await requestMotionPermission()
    }
    
    private func requestHealthKitPermission() async throws {
        // 请求健康数据读取权限
    }
}
```

#### 6.2 本地数据处理
- 所有计算在设备本地完成
- 不上传任何个人使用数据到服务器
- 支持iCloud端到端加密同步（可选）
- 提供数据导出和删除功能

### 7. 错误处理与边界情况

#### 7.1 数据缺失处理
```swift
enum DataQuality {
    case high    // 多源数据完整
    case medium  // 部分数据源缺失
    case low     // 主要数据源缺失
}

class DataQualityChecker {
    func assessQuality(for date: Date) -> DataQuality {
        // 根据可用数据源评估数据质量
    }
}
```

#### 7.2 边界情况处理
- 设备重启后的数据恢复
- 健康数据权限被拒绝的降级方案
- 运动传感器不可用的备用算法
- 跨时区旅行的数据处理

### 8. 性能优化

#### 8.1 后台处理
```swift
class BackgroundTaskManager {
    func scheduleFocusCalculation() {
        let request = BGAppRefreshTaskRequest(identifier: "com.focusapp.calculation")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
        BGTaskScheduler.shared.submit(request)
    }
}
```

#### 8.2 电池优化
- 批处理传感器数据读取
- 智能调整检测频率（基于用户习惯）
- 使用低功耗模式检测策略

## 技术栈

- **语言**: Swift 5.8+
- **框架**: SwiftUI, Combine, HealthKit, CoreMotion, WidgetKit
- **最低版本**: iOS 15.0
- **推荐版本**: iOS 16.0+（支持更完善的API）

## 依赖库

```swift
// Swift Package Manager 依赖
.healthKit
.coreMotion
.userNotifications
.widgetKit
.backgroundTasks
```

## 测试策略

### 单元测试
- 专注算法准确性测试
- 数据存储和读取测试
- 边界情况处理测试

### 集成测试
- 多数据源融合测试
- iOS系统API兼容性测试
- 小组件和推送功能测试

### 用户测试
- 20人内测，验证检测准确性
- 电池消耗测试
- 隐私权限体验测试
