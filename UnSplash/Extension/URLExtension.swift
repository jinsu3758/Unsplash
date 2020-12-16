//
//  URLExtension.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/12.
//

import Foundation

extension URL {
    func add(query: [String:String]) -> URL? {
        guard var urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        var queryItems: [URLQueryItem] = []
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponent.queryItems = queryItems
        return urlComponent.url
    }
    
    func add<T: Encodable>(query: T) -> URL? {
        guard var urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        var queryItems: [URLQueryItem] = []
        guard let query = query.dictionary else { return nil }
        
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        urlComponent.queryItems = queryItems
        return urlComponent.url
    }
}

extension URLRequest {
    mutating func add(header: [String:String]) {
        for (key, value) in header {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }

}

