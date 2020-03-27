//
//  GameCell.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-19.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    static let reuseID = "GameCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func setGame(to game: Game) {
        nameLabel.text = game.getName()
        downloadImage(fromURL: game.getThumbnailURL())
    }
    
    func downloadImage(fromURL urlString: String?) {
        guard let urlString = urlString else { return }
        NetworkManager.shared.downloadImage(from: urlString) { (image) in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
}
