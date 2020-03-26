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
    
    func setGame(to game: Game) {
        nameLabel.text = game.getName()
    }
}
