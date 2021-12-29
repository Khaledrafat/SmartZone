//
//  BaseNetwork.swift
//  Task
//
//  Created by Khaled on 24/12/2021.
//

import UIKit

public enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
        case trace = "TRACE"
        case connect = "CONNECT"
}

class BaseNetwork {
    
    //MARK: - Call API Service
    final func callService<T : Codable>(url : String , method : HTTPMethod = .get , body : [String : Any]? = nil , param : [String : Any]? = nil , header : [String : Any]? = nil , completionHandler : @escaping (Result<T? , ResultErrors>)->()) {
        guard var components = URLComponents(string: url) else {
            completionHandler(.failure(.err_message("URL ERROR")))
            return
        }
        
        if let parameter = param {
            components.queryItems = parameter.map({ (key , value) in
                return URLQueryItem(name: key, value: "\(value)")
            })
        }
        
        guard let reqUrl = components.url else { return }
        var request = URLRequest(url: reqUrl)
        request.httpMethod = method.rawValue
        
        if let head = header {
            head.forEach({ (key , value) in
                request.setValue(key, forHTTPHeaderField: "\(value)")
            })
        }
        
        if let bodyParam = body {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyParam, options: []) else {
                    return
                }
                request.httpBody = httpBody
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Request URL IS \(request.url)")
            guard error == nil else {
                completionHandler(.failure(.err_message(error.debugDescription)))
                return
            }
            
            guard let data = data , let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.err_message("No Data")))
                return
            }
            
            guard response.statusCode == 200 else {
                completionHandler(.failure(.err_message("Status Code Error")))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                print("Response is \(responseData)")
                completionHandler(.success(responseData))
            } catch {
                print(error)
                completionHandler(.failure(.err_message(error.localizedDescription)))
            }
        }.resume()
        
    }
    
}
