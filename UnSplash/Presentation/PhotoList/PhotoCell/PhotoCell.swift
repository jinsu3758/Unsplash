//
//  ImageCell.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/12.
//

import UIKit

class PhotoCell: UITableViewCell {
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    fileprivate func initView() {
        self.contentView.addSubview(contentImageView)
        
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func fill(_ image: UIImage?) {
        contentImageView.image = image
    }
}
