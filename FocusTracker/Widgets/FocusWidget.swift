import WidgetKit
import SwiftUI

struct FocusWidgetEntry: TimelineEntry {
    let date: Date
    let focusMinutes: Int
}

struct FocusWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> FocusWidgetEntry {
        FocusWidgetEntry(date: Date(), focusMinutes: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (FocusWidgetEntry) -> ()) {
        let entry = FocusWidgetEntry(date: Date(), focusMinutes: FocusDetectionEngine.shared.todayFocusMinutes())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FocusWidgetEntry>) -> ()) {
        let entry = FocusWidgetEntry(date: Date(), focusMinutes: FocusDetectionEngine.shared.todayFocusMinutes())
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(next))
        completion(timeline)
    }
}

struct FocusWidgetView : View {
    var entry: FocusWidgetProvider.Entry

    var body: some View {
        Text("Focus \(entry.focusMinutes)min")
    }
}

@main
struct FocusWidget: Widget {
    let kind: String = "FocusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusWidgetProvider()) { entry in
            FocusWidgetView(entry: entry)
        }
        .configurationDisplayName("Focus Time")
        .description("Show today's focus minutes")
    }
}
