//
//  Reminder..swift
//  RemindersApp
//
//  Created by Sajed Shaikh on 03/11/25.
//

import Foundation

struct MyReminder: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var isCompleted: Bool = false
    
    init(title: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.date = date
    }
}
