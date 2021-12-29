//
//  Home.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import Foundation

protocol HomeNetworkProtocol {
    func getHomeTVShows(fromDate : String , page : Int , completionHandler : @escaping (Result<ArticleRoot?, ResultErrors>)->())
}

class HomeNetwork : HomeNetworkProtocol {
    
    var networkClass = BaseNetwork()
    
    func getHomeTVShows(fromDate : String , page : Int ,completionHandler : @escaping (Result<ArticleRoot?, ResultErrors>)->()) {
        let param = ["q" : "Apple" , "from" : fromDate , "sortBy" : "popularity" , "apiKey" : Keys.api_key.key , "page" : "\(page)"]
        networkClass.callService(url: URLS.home.url, param: param) { (result : Result<ArticleRoot? , ResultErrors>) in
            completionHandler(result)
        }
    }
    
}
