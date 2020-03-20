//
//  GameCell.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-19.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    static let reuseID = "GameCell"
    let thumbnailImageView = ThumbnailImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(thumbnailImageView)
    }
}
