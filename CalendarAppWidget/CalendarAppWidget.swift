//
//  CalendarAppWidget.swift
//  CalendarAppWidget
//
//  Created by Vika Granadzer on 07.05.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let itemsAll = (try? getData()) ?? []
        
        return SimpleEntry(date: Date(), itemsAll: itemsAll)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do{
            let itemsAll = try getData()
            let entry = SimpleEntry(date: Date(), itemsAll: itemsAll)
            completion(entry)
        }
        catch{
            print(error)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do{
            let itemsAll = try getData()
            let entry = SimpleEntry(date: Date(), itemsAll: itemsAll)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
        catch{
            print(error)
        }
    }
    
    private func getData() throws -> [TaskToDo]{
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request = TaskToDo.fetchRequest()
        let result = try context.fetch(request)
        let array: [TaskToDo] = createArray(result: result)
        
        return array
    }
}

struct SimpleEntry: TimelineEntry{
    let date: Date
    let itemsAll: [TaskToDo]
}

struct CalendarAppWidgetEntryView : View {
    var entry: Provider.Entry
    let pinkish : Color = Color(red: 1, green: 161/255, blue: 159/255)
    
    var body: some View{
        VStack{
            VStack{
                if (entry.itemsAll.count != 0){
                    VStack{
                        Text("Tasks for today")
                            .font(.system(size: 14).bold())
                            .foregroundColor(pinkish)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal,2)
                    .padding(.vertical, 7)
                    VStack{
                        ForEach(entry.itemsAll){
                            item in
                            Text(item.title ?? "!!")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topLeading)
                        .padding(.horizontal,4)
                    }
                }
                else{
                    VStack{
                        Text("No tasks for today")
                            .font(.system(size: 14).bold())
                            .foregroundColor(pinkish)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal,4)
                    .padding(.vertical, 40)
                }
            }
        }
    }
}

struct CalendarAppWidget: Widget {
    let kind: String = "ToDoModel"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()){
            entry in
            CalendarAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("Tasks!!!")
    }
}

struct CalendarAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAppWidgetEntryView(entry: SimpleEntry(date: Date(), itemsAll: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
