//
//  UIViewExtension.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/12.
//

import UIKit

extension UIView {
    class var className: String {
        return String.init(describing: self).components(separatedBy: ".").last!
    }
}

extension UIImageView {
    func load(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
            }
        }).resume()
    }
}
