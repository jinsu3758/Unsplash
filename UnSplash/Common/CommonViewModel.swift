//
//  CommonViewModel.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import Foundation
import UIKit

enum AlertType {
    case emptyResult
    case networkError
    
    var description: String {
        switch self {
        case .emptyResult:
            return "결과가 없습니다."
        case .networkError:
            return "네트워크 에러"
        }
    }
}

class CommonViewModel {
    let service: ApiServiceType
    let coordinator: CoordinatorType
    
    init(service: ApiServiceType, coordinator: CoordinatorType) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func alert(_ type: AlertType) {
        DispatchQueue.main.async {
            self.coordinator.alert(type.description)
        }
    }
    
    func downloadImage(_ items: [PhotoListResponse], completion: @escaping ([Photo]) -> Void) {
        var result: [Photo] = []
        for item in items {
            let domain = item.toDomain()
            domain.load {
                result.append(domain)
                if result.count == items.count {
                    completion(result)
                }
            }
        }
        
    }
    
    func downloadImage(_ items: [SearchResult], completion: @escaping ([Photo]) -> Void) {
        var result: [Photo] = []
        for item in items {
            let domain = item.toDomain()
            domain.load {
                result.append(domain)
                if result.count == items.count {
                    completion(result)
                }
            }
        }
        
    }
}
