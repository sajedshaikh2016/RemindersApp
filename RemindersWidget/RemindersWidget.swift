//
//  RemindersWidget.swift
//  RemindersWidget
//
//  Created by Sajed Shaikh on 03/11/25.
//

import WidgetKit
import SwiftUI

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
    MyReminder(title: "do DSA", date: Date()),
    MyReminder(title: "take a nap", date: Date()),
    MyReminder(title: "work on the project", date: Date())
]

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let reminders: [MyReminder]
}

struct RemindersWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("{ }")
                    .foregroundColor(.orange)
                    .font(.title)
                Text("\(entry.reminders.count)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                Text("Reminders")
                    .foregroundColor(.orange)
                
                ForEach(entry.reminders.prefix(3), id: \.title) { reminder in
                    HStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 12, height: 12)
                        Text(reminder.title)
                            .foregroundColor(.white)
                            .font(.callout)
                        Spacer()
                        Text(reminder.date, style: .time)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
    }
}

struct RemindersWidget: Widget {
    let kind: String = "RemindersWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            RemindersWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Reminders")
        .description("Stay on top of your tasks.")
        .supportedFamilies([.systemSmall, .systemMedium])
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

