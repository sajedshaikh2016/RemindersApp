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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), reminders: sampleReminders)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, reminders: sampleReminders)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, reminders: sampleReminders)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

let sampleReminders = [
    MyReminder(title: "Take a nap", date: Date()),
    MyReminder(title: "Work on the project", date: Date())
]

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let reminders: [MyReminder]
}

struct RemindersWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        
        ZStack {
            
            HStack {
                VStack(spacing: 2, content: {
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
                })
                
                VStack(spacing: 2, content: {
                    ForEach(entry.reminders.prefix(3)) { reminder in
                        HStack {
                            Button(intent: MarkReminderDoneIntent(id: .init(title: LocalizedStringResource(stringLiteral: reminder.id.uuidString)))) {
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
                })
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

