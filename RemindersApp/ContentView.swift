//
//  ContentView.swift
//  RemindersApp
//
//  Created by Sajed Shaikh on 03/11/25.
//

import SwiftUI
import WidgetKit


struct ContentView: View {
    @State private var reminders: [MyReminder] = ReminderStore.shared.load()
    @State private var newTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders) { reminder in
                        HStack {
                            Text(reminder.title)
                            Spacer()
                            Text(reminder.date, style: .time)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack {
                    TextField("New reminder", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        let new = MyReminder(title: newTitle, date: Date())
                        reminders.append(new)
                        ReminderStore.shared.save(reminders)
                        WidgetCenter.shared.reloadAllTimelines()
                        newTitle = ""
                    }
                }
                .padding()
            }
            .navigationTitle("Reminders")
        }
    }
}

#Preview {
    ContentView()
}
