//
//  ContentView.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 04.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
