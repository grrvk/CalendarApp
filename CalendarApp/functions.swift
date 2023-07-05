//
//  functions.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 07.05.2023.
//

import Foundation
import SwiftUI

func dateD(date: Date) -> Int?{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: date)
    let day = components.day
    return day
}

func dateM(date: Date) -> Int?{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month], from: date)
    let month = components.month
    return month
}

func dateY(date: Date) -> Int?{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: date)
    let year = components.year
    return year
}

func createArray(result: [TaskToDo]) -> [TaskToDo]{
    var array: [TaskToDo] = []
    
    for res in result{
        if ((dateD(date: res.taskDate!) == dateD(date: Date())) && (dateM(date: res.taskDate!) == dateM(date: Date())) && (dateY(date: res.taskDate!) == dateY(date: Date()))){
            array.append(res)
        }
    }
    print(array)
    return array
}
