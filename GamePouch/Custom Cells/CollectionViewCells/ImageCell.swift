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
    
    func loadImage(from imageURL: String) {
        NetworkManager.shared.downloadImage(from: imageURL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        imageView.layer.cornerRadius = 12
    }
}
