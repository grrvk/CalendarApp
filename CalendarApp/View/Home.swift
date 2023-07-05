//
//  Home.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 04.05.2023.
//

import SwiftUI

struct Home: View {
    
    @State var currentDate: Date = Date()
    let pinkish : Color = Color(red: 1, green: 161/255, blue: 159/255)
    
    var body: some View {
        ScrollView{
            CustomDatePicker(currentDate: $currentDate).environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Home()
        }
    }
}
