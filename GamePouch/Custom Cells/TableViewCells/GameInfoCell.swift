//
//  GameInfoCell.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-19.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit
import CoreData

class GameInfoCell: UITableViewCell {
    
    static let reuseID = "GameInfoCell"
    var game: Game?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numPlayersLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var minAgeLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    
    func getGame() -> Game? {
        return self.game
    }
    
    func setGame(to game: Game) {
        self.game = game
        nameLabel.text = game.getName()
        numPlayersLabel.text = isValid(game.getMinPlayers()) && isValid(game.getMaxPlayers()) ? "\(game.getMinPlayers()!)-\(game.getMaxPlayers()!)" : "N/A"
        ratingLabel.text = isValid(game.getRating()) ? game.getRating() : "N/A"
        playtimeLabel.text = isValid(game.getPlayingTime()) ? "\(game.getPlayingTime()!)m" : "N/A"
        weightLabel.text = isValid(game.getWeight()) ? game.getWeight() : "N/A"
        rankLabel.text = isValid(game.getRank()) ? "\(game.getRank()!)th" : "N/A"
        minAgeLabel.text = isValid(game.getMinAge()) ? "\(game.getMinAge()!)+" : "N/A"
        downloadImage(fromURL: game.getThumbnailURL())
    }
    
    func isValid(_ text: String?) -> Bool {
        return text != nil && text != "0" && text != "0.0" && text != "Not Ranked"
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
