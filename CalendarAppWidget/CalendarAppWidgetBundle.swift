//
//  CalendarAppWidgetBundle.swift
//  CalendarAppWidget
//
//  Created by Vika Granadzer on 07.05.2023.
//

import WidgetKit
import SwiftUI

@main
struct CalendarAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalendarAppWidget()
        CalendarAppWidgetLiveActivity()
    }
}
