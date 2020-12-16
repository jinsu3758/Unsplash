//
//  LifeCycleViewModel.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/14.
//

import Foundation

@objc protocol LifeCycleViewModelProtocol: class {
    // MARK: - ViewController LifeCycle
    @objc optional func viewDidLoad()
    @objc optional func viewWillAppear(_ animated: Bool)
    @objc optional func viewDidAppear(_ animated: Bool)
    @objc optional func viewWillDisappear(_ animated: Bool)
    @objc optional func viewDidDisappear(_ animated: Bool)

}
