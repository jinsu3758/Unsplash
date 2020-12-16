//
//  PhotoList.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import Foundation
import UIKit

class Photo {
    let id: String
    let urlString: String
    var image: UIImage?
    
    init(id: String, urlString: String) {
        self.id = id
        self.urlString = urlString
    }
    
    func load( completion: @escaping () -> Void) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            self.image = UIImage(data: data)
            completion()
        }).resume()
    }
    
}
