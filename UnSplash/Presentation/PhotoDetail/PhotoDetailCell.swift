//
//  PhotoDetailCell.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import UIKit

class PhotoDetailCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func fill(_ image: UIImage?) {
        imageView.image = image
    }
}
