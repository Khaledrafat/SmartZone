//
//  ProjectURLS.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import Foundation

enum URLS {
    case home
    
    var url : String {
        switch self {
        case .home: return "https://newsapi.org/v2/everything"
        }
    }
}

enum Keys {
    case api_key
    
    var key : String {
        switch self {
        case .api_key : return "15980136546e477eba1e643cb7f0c253"
        }
    }
}
