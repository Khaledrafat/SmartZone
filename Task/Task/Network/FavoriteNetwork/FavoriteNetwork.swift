//
//  FavoriteNetwork.swift
//  Task
//
//  Created by Khaled on 29/12/2021.
//

import Foundation

protocol FavoriteNetworkProtocol {
    func getLocalData(completionHandler : @escaping (Result<[Article], ResultErrors>)->())
}

class FavoriteNetwork : FavoriteNetworkProtocol {
    
    func getLocalData(completionHandler : @escaping (Result<[Article], ResultErrors>)->()) {
        guard let data = CoreDataBase().getAllData() else {
            completionHandler(.success([Article]()))
            return
        }
        let value = data.map({ Article($0) })
        completionHandler(.success(value))
    }
    
}
