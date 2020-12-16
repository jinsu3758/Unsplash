//
//  SceneCoordinator.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/15.
//

import UIKit

enum TransitionStyle {
    case modal(UIModalTransitionStyle)
    case push
}

protocol CoordinatorType {
    func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)?)
    func close(to scene: Scene?, animated: Bool, completion: (() -> Void)?)
    func popWithBackButton()
    func alert(_ message: String)
}

class SceneCoordinator: CoordinatorType {
    private var currentViewController: UIViewController
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.currentViewController = navigationController
    }

    func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)? = nil) {
        let target = scene.viewController()
        
        switch style {
        case .push:
            navigationController.pushViewController(target, animated: animated)
            currentViewController = target
            completion?()
        case .modal(let modalStyle):
            currentViewController.modalTransitionStyle = modalStyle
            currentViewController.present(target, animated: animated, completion: completion)
            currentViewController = target
        }
    }
    
    func close(to scene: Scene?, animated: Bool, completion: (() -> Void)? = nil) {
        if let presentingViewController = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated, completion: completion)
            currentViewController = presentingViewController
        }
        else {
            navigationController.popViewController(animated: animated)
            currentViewController = navigationController.viewControllers.last!
            completion?()
        }
    }
    
    func popWithBackButton() {
        currentViewController = navigationController.viewControllers.last!
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
    }
}
