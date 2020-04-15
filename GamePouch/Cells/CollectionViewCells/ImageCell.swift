//
//  ImageCell.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-04-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(to image: UIImage) {
        imageView.image = image
        imageView.layer.cornerRadius = 12
    }
}
