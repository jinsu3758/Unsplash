//
//  ApiService.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/12.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case unknown
    case endPointError
    
    init(with statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500, 503:
            self = .endPointError
        default:
            self = .unknown
        }
    }
    
    var errorDescription: String? {
        let prefix = "Network Error - "
        switch self {
        case .invalidURL:
            return prefix + "URL is invalid"
        case .badRequest:
            return prefix + "The request was unacceptable, often due to missing a required parameter"
        case .unauthorized:
            return prefix + "Invalid Access Token"
        case .forbidden:
            return prefix + "The request was unacceptable, often due to missing a required parameter"
        case .notFound:
            return prefix + "The request was unacceptable, often due to missing a required parameter"
        case .endPointError:
            return prefix + "Something went wrong on API Server end"
        case .unknown:
            return prefix + "unknown"
        }
    }
    
}

enum NetworkResponse {
    case success
    case clientError(Error)
    case serverError(Error)
    
    init(from response: URLResponse?) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        
        switch statusCode {
        case 200..<300:
            self = .success
        case 400..<500:
            self = .clientError(NetworkError(with: statusCode))
        default:
            self = .serverError(NetworkError(with: statusCode))
        }
    }
    
}

protocol ApiServiceType {
    func fetch<T: Decodable, E: Encodable>(_ endpoint: EndPointable, parameter: E?, header: [String:String]?, completion: @escaping (Result<T?, Error>) -> Void)
    
    func fetch<T: Decodable>(_ endpoint: EndPointable, query: [String:String], header: [String:String]?, completion: @escaping (Result<T?, Error>) -> Void)

}

class ApiService: ApiServiceType {
    fileprivate let urlSession = URLSession.shared
    fileprivate var dataTask: URLSessionTask?
    
    
    func fetch<T, E>(_ endpoint: EndPointable, parameter: E?, header: [String:String]? = nil, completion: @escaping (Result<T?, Error>) -> Void) where T: Decodable, E: Encodable {
        var url = endpoint.fullURL
        
        if endpoint.httpMethod == .get || endpoint.httpMethod == .delete, let parameter = parameter {
            url = url?.add(query: parameter)
        }
        guard let requestURL = url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request: URLRequest = URLRequest(url: requestURL)
        if let header = header { request.add(header: header) }
        if let endPointHeadar = endpoint.headers { request.add(header: endPointHeadar) }
        request.httpMethod = endpoint.httpMethod.rawValue
        
        if endpoint.httpMethod == .post || endpoint.httpMethod == .put {
            request.httpBody = try? JSONEncoder().encode(parameter)
        }
        
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                self.printError(error)
                completion(.failure(error))
            }
            
            let result = NetworkResponse(from: response)
            switch result {
            case .success:
                guard let data = data else {
                    completion(.failure(NetworkError.unknown))
                    break
                }
                let item = try? JSONDecoder().decode(T.self, from: data)
                completion(.success(item))
                
            case .clientError(let error):
                self.printError(error)
                completion(.failure(error))
            case .serverError(let error):
                self.printError(error)
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
        
    }

    
    func fetch<T>(_ endpoint: EndPointable, query: [String:String], header: [String:String]? = nil, completion: @escaping (Result<T?, Error>) -> Void) where T: Decodable {
        
        guard let url = endpoint.fullURL?.add(query: query) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        if let header = header { request.add(header: header) }
        if let endPointHeadar = endpoint.headers { request.add(header: endPointHeadar) }
        request.httpMethod = endpoint.httpMethod.rawValue
        
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                self.printError(error)
                completion(.failure(error))
            }
            
            let result = NetworkResponse(from: response)
            switch result {
            case .success:
                guard let data = data else {
                    completion(.failure(NetworkError.unknown))
                    break
                }
                
                let item = try! JSONDecoder().decode(T.self, from: data)
                completion(.success(item))
                
            case .clientError(let error):
                self.printError(error)
                completion(.failure(error))
            case .serverError(let error):
                self.printError(error)
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
        
    }
    
    fileprivate func printError(_ error: Error) {
        NSLog(error.localizedDescription)
    }

    
    
}
