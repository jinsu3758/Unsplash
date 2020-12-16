//
//  EndPoint.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/12.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPointable {
    var baseURL: String { get }
    var path: String? { get }
    var fullURL: URL? { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String:String]? { get }
}

enum EndPoint {
    case photoList
    case searchPhoto
}

extension EndPoint: EndPointable {
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var path: String? {
        switch self {
        case .photoList:
            return "photos"
        case .searchPhoto:
            return "search/photos"
        }
    }
    
    var fullURL: URL? {
        return URL(string: baseURL + (path ?? ""))
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .photoList, .searchPhoto:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .photoList, .searchPhoto:
            let key = "Authorization"
            guard let value = KeychainManager.shared.get(key) else { return nil }
            return ["Authorization" : value]
        }
    }
    
}
