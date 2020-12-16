//
//  Scene.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/15.
//

import UIKit

enum Scene {
    case photoList(PhotoListViewModel)
    case photoDetail(PhotoDetailViewModel)
    
    var storyboardName: String {
        switch self {
        case .photoList, .photoDetail:
            return "Main"
        }
    }
    
    var identifier: String {
        switch self {
        case .photoList:
            return "PhotoListVC"
        case .photoDetail:
            return "PhotoDetailVC"
        }
    }
    
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let target = storyboard.instantiateViewController(withIdentifier: self.identifier)
        
        switch self {
        case .photoList(let viewModel):
            guard let viewController = target as? PhotoListViewController else { break }
            viewController.viewModel = viewModel
            return viewController
        case .photoDetail(let viewModel):
            guard let viewController = target as? PhotoDetailViewController else { break }
            viewController.viewModel = viewModel
            return viewController
        }
        
        return target
    }
}
