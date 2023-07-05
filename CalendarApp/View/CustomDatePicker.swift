//
//  CustomDatePicker.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 04.05.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    
    let pinkish : Color = Color(red: 1, green: 161/255, blue: 159/255)
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    @Binding var currentDate: Date 
    
    @State var currentMonth: Int = 0
    
    @FetchRequest(entity: TaskToDo.entity(), sortDescriptors: [NSSortDescriptor(key: "taskDate", ascending: false)]) private var allTasks: FetchedResults<TaskToDo>
    
    @FetchRequest(entity: TaskToDo.entity(), sortDescriptors: [NSSortDescriptor(key: "star", ascending: false)], predicate: NSPredicate(format: "star == %d", true)) var allStarTasks: FetchedResults<TaskToDo>
    
    var body: some View {
        VStack(spacing: 35){
            
            let days: [String] =
                ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                
                Button{
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button{
                    withAnimation{
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0){
                ForEach(days,id: \.self){
                    day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            HStack{
                LazyVGrid(columns: columns, spacing: 15){
                    ForEach(extractDate()){
                        value in
                        CardView(value: value)
                            .background(
                                Capsule()
                                    .fill(pinkish)
                                    .padding(.horizontal, 8)
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
            }
            
            HStack{
                NavigationLink(destination: ToDo(date: currentDate).environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
                , label: {
                Text("View tasks for \(currentDate.formatted(.dateTime.day().month().year()))")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(pinkish)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                })
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: currentMonth){
            newValue in
            currentDate = getCurrentMonth()
        }
        VStack{
            VStack{
                Text("Stats")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                
                Text("Total number of all tasks: \(allTasks.count)")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                Text("Total number of all star tasks: \(allStarTasks.count)")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(pinkish)
        .safeAreaInset(edge: .bottom){
            Button(action: {}, label: {
                Image(systemName: "gear")
                    .font(.title)
                    .foregroundColor(.white)
            })
            .frame(maxWidth: .infinity)
        }
        
        
    }
    @ViewBuilder
    func starsCount()->some View{
        VStack{
            
        }
    }
        
    @ViewBuilder
    func CardView(value: DateValue)->some View{
        VStack{
                
            if value.day != -1{
                    
                if let task = allTasks.first(where: {
                    task in isSameDay(date1: task.taskDate!, date2: value.date)
                })
                {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.taskDate!, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.taskDate!, date2: currentDate) ? .white :
                            pinkish)
                        .frame(width: 8, height: 8)
                }
                else{
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
                
        }
        .padding(.vertical, 9)
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
    
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate()->[String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{
            date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days[6].date)
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}

extension Date{
    func getAllDates()->[Date]{
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
