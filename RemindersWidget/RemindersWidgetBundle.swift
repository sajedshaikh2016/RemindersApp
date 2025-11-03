//
//  RemindersWidgetBundle.swift
//  RemindersWidget
//
//  Created by Sajed Shaikh on 03/11/25.
//

import WidgetKit
import SwiftUI

@main
struct RemindersWidgetBundle: WidgetBundle {
    var body: some Widget {
        RemindersWidget()
        RemindersWidgetControl()
        RemindersWidgetLiveActivity()
    }
}
