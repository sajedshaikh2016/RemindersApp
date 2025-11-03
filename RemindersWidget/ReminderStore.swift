//
//  ReminderStore.swift
//  RemindersApp
//
//  Created by Sajed Shaikh on 03/11/25.
//

import Foundation

class ReminderStore {
    static let shared = ReminderStore()
    private let userDefaults = UserDefaults(suiteName: "group.com.sajedshaikh.reminders")!
    private let key = "reminders"

    func save(_ reminders: [MyReminder]) {
        if let data = try? JSONEncoder().encode(reminders) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func load() -> [MyReminder] {
        guard let data = userDefaults.data(forKey: key),
              let reminders = try? JSONDecoder().decode([MyReminder].self, from: data) else {
            return []
        }
        return reminders
    }
}
