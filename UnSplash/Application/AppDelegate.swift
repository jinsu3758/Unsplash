//
//  AppDelegate.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let service = ApiService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let keyChainManager = KeychainManager.shared
        if keyChainManager.isEmpty("Authorization") {
            keyChainManager.set("Client-ID bBJD03JBOn2uRPXADI-j4BwHL0HKsfscY-TGeXyvllY", key: "Authorization")
        }
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            let coordinator = SceneCoordinator(navigationController: navigationController)
            let viewModel = PhotoListViewModel(service: service, coordinator: coordinator)
            
            coordinator.transition(to: Scene.photoList(viewModel), style: .push, animated: true)
        }
        
        return true
    }


}

