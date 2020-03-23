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
    private let rankLabel = UILabel()
    private let thumbnailImageView = ThumbnailImageView(frame: .zero)
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let weightLabel = UILabel()
    private let numPlayersLabel = UILabel()
    private let playtimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(rankLabel, thumbnailImageView, titleLabel, ratingLabel, weightLabel, numPlayersLabel, playtimeLabel)
    }
    
    //TODO: set gamecell properties
}
