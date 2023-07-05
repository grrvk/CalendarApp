//
//  ToDo.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 05.05.2023.
//

import SwiftUI
import WidgetKit

struct ToDo: View {
    
    let pinkish : Color = Color(red: 1, green: 161/255, blue: 159/255)
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    let date: Date
    let dateFormatter = DateFormatter()
    
    @State private var title: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: TaskToDo.entity(), sortDescriptors: [NSSortDescriptor(key: "taskDate", ascending: false)]) private var allTasks: FetchedResults<TaskToDo>
    
    private func saveTask(){
        do {
            let task = TaskToDo(context: viewContext)
            task.title = title
            task.taskDate = date
            try viewContext.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private func updateTask(_ task: TaskToDo){
        task.star = !task.star
        do {
            try viewContext.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet){
        offsets.forEach{
            index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do{
                try viewContext.save()
            } catch{
                print(error.localizedDescription)
            }
            
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    var body: some View {
        NavigationView{
            
            VStack{
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Button("Save"){
                    saveTask()
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(pinkish)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List{
                    ForEach(allTasks) {
                        task in
                        if ((dateD(date: task.taskDate!) == dateD(date: date)) && (dateM(date: task.taskDate!) == dateM(date: date)) && (dateY(date: task.taskDate!) == dateY(date: date))){
                            HStack{
                                Text(task.title ?? "")
                                Spacer()
                                Image(systemName: task.star ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        updateTask(task)
                                    }
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("All tasks")
        }
    }
}

struct ToDo_Previews: PreviewProvider {
    static var previews: some View {
        ToDo(date: Date()).environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}
