//
//  ResultErrorEnum.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import Foundation

enum ResultErrors : Error {
    
    case err_message(_ message : String)
    
    var errorMessage : String {
        switch self {
        case .err_message(let message):
            return message
        }
    }
    
}
