//
//  NetworkManager.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-20.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

enum SearchType {
    case search
    case hotness
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private let baseURL = "https://www.boardgamegeek.com/xmlapi2/"
//    private let generalSearchURL = "search?type=boardgame,boardgameexpansion&query="
    private let getGameURL = "thing?type=boardgame,boardgameexpansion&stats=1&id="
    private let hotGamesURL = "hot?type=boardgame,boardgameexpansion"
    
    private override init() {}
    
    func getHotnessList(type: SearchType, onComplete: @escaping ([Game]) -> ()) {
        let finalURL = baseURL + hotGamesURL
        guard let url = URL(string: finalURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let hotGamesParser = HotGamesParser()
            if hotGamesParser.fromXML(data: data) {
                let group = DispatchGroup()
                var games = [Game]()
                
                for hotGame in hotGamesParser.games {
                    group.enter()
                    if let id = hotGame.getId() {
                        self.getGame(id: id) { (game) in
                            games.append(game)
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    onComplete(games)
                }
            } else {
                //
            }
        }
        task.resume()
    }
    
    func getGame(id: String, onComplete: @escaping (Game) -> ()) {
        let finalURL = baseURL + getGameURL + id
        guard let url = URL(string: finalURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let getGameParser = GetGameParser()
            if getGameParser.fromXML(data: data) {
                onComplete(getGameParser.game)
            } else {
                
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, onComplete: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            onComplete(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    onComplete(nil)
                    return
            }
            onComplete(image)
        }
        task.resume()
    }
}

