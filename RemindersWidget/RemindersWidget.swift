//
//  RemindersWidget.swift
//  RemindersWidget
//
//  Created by Sajed Shaikh on 03/11/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
    private func fetchReminders() -> [ReminderItem] {
        // TODO: Wire up a shared data provider for real reminders accessible by the widget extension.
        return sampleReminders
    }

    func placeholder(in context: Context) -> SimpleEntry {
        let reminders = fetchReminders()
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), reminders: reminders)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let reminders = fetchReminders()
        return SimpleEntry(date: Date(), configuration: configuration, reminders: reminders)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let reminders = fetchReminders()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, reminders: reminders)
            entries.append(entry)
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct ReminderItem: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let isCompleted: Bool

    init(id: UUID = UUID(), title: String, date: Date, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
}

let sampleReminders = [
    ReminderItem(title: "Take a nap", date: Date(), isCompleted: false),
    ReminderItem(title: "Work on the project", date: Date().addingTimeInterval(3600), isCompleted: true)
]

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let reminders: [ReminderItem]
}

struct RemindersWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            HStack {
                VStack(spacing: 2) {
                    Text("{ }")
                        .foregroundColor(.orange)
                        .font(.title)
                    Text("\(entry.reminders.count)")
                        .font(.system(size: 50, weight: .heavy))
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.6))
                    Text("Reminders")
                        .font(.title3)
                        .foregroundColor(.orange)
                }

                VStack(spacing: 2) {
                    ForEach(entry.reminders.prefix(3)) { reminder in
                        HStack {
                            Button(intent: MarkReminderDoneIntent()) {
                                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(reminder.isCompleted ? .orange : .gray)
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(.plain)

                            Text(reminder.title)
                                .foregroundColor(reminder.isCompleted ? .gray : .white)
                                .strikethrough(reminder.isCompleted)

                            Spacer()
                            Text(reminder.date, style: .time)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct RemindersWidget: Widget {
    let kind: String = "RemindersWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            RemindersWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Reminders")
        .description("Stay on top of your tasks.")
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    RemindersWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, reminders: sampleReminders)
    SimpleEntry(date: .now, configuration: .starEyes, reminders: sampleReminders)
}

