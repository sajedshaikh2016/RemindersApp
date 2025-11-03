//
//  MarkReminderDoneIntent.swift
//  RemindersApp
//
//  Created by Sajed Shaikh on 03/11/25.
//

import AppIntents
import WidgetKit

struct MarkReminderDoneIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark Reminder as Done"
    static var description = IntentDescription("Marks a reminder as completed")

    @Parameter(title: "Reminder ID")
    var id: String

    func perform() async throws -> some IntentResult {
        var reminders = await ReminderStore.shared.load()
        if let index = reminders.firstIndex(where: { $0.id.uuidString == id }) {
            reminders[index].isCompleted.toggle()
            await ReminderStore.shared.save(reminders)
            WidgetCenter.shared.reloadAllTimelines()
        }
        return .result()
    }
}
