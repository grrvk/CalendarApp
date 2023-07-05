//
//  filteredTask.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 06.05.2023.
//

import SwiftUI

struct filteredTask: View {
    
    @FetchRequest var fetchRequest: FetchedResults<TaskToDo>
    init() {
        _fetchRequest = FetchRequest<TaskToDo>(sortDescriptors: [], predicate: NSPredicate(format: "@anAttribute == YES"))
    }
    var body: some View {
        Text("\(fetchRequest.count)")
    }
}

struct filteredTask_Previews: PreviewProvider {
    static var previews: some View {
        filteredTask()
    }
}
