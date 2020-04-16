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
    let imageCache = NSCache<NSString, UIImage>()
    private let baseURL = "https://www.boardgamegeek.com/xmlapi2/"
//    private let generalSearchURL = "search?type=boardgame,boardgameexpansion&query="
    private let getGameURL = "thing?type=boardgame,boardgameexpansion&stats=1&videos=1&id="
    private let hotGamesURL = "hot?type=boardgame,boardgameexpansion"
    private let galleryImageURL = "https://api.geekdo.com/api/images?ajax=1&gallery=all&nosession=1&objecttype=thing&pageid=1&showcount=36&size=thumb&sort=hot&objectid="
    
    private override init() {}
    
    func getHotnessList(type: SearchType, onComplete: @escaping ([Game]) -> ()) {
        let endpoint = baseURL + hotGamesURL
        guard let url = URL(string: endpoint) else { return }
        
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
        let endpoint = baseURL + getGameURL + id
        guard let url = URL(string: endpoint) else { return }
        
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
        let cacheKey = NSString(string: urlString)
        
        if let image = imageCache.object(forKey: cacheKey) {
            onComplete(image)
            return
        }
        
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
            self.imageCache.setObject(image, forKey: cacheKey)
            onComplete(image)
        }
        task.resume()
    }
    
    func getGalleryImageURLs(for id: String, onComplete: @escaping ([String]) -> ()) {
        let endpoint =  galleryImageURL + "\(id)"
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let gameImages = try decoder.decode(GameImages.self, from: data)
                var imageURLs = [String]()
                
                for gameImage in gameImages.images {
                    imageURLs.append(gameImage.imageurlLg)
                }
                onComplete(imageURLs)
            } catch {
                return
            }
        }
        task.resume()
    }
}

