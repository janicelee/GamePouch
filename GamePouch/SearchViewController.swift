//
//  SearchViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-19.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let networkManager = NetworkManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.searchForGame(displayGames)
    }
    
    func displayGames(_ games: [Game]) {
        for game in games {
            print("name: \(game.name), year: \(game.yearPublished)")
        }
    }
}
