//
//  EgyptTimeZone.swift
//  Task
//
//  Created by Khaled on 28/12/2021.
//

import Foundation

class TimeZone {
    
    func getEgyTimeZone() -> String {
        let currentData = Date()
        let date = Calendar.current.date(byAdding: .day, value: -1, to: currentData)
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EG")
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        print("Date is \(dateString)")
        return dateString
    }
    
}
