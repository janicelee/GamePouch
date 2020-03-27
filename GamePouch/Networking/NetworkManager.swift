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
    private let searchURL = "search?type=boardgame,boardgameexpansion&query="
    private let hotnessURL = "hot?type=boardgame,boardgameexpansion"
    
    private var searchResult = SearchResult()
    private var tempGame = Game()
    private var contentBuffer = String()
    
    private override init() {}
    
    func retrieveGames(type: SearchType, title: String = "", onComplete: @escaping ([Game]) -> ()) {
        let finalURL = baseURL + (type == SearchType.search ? (searchURL + title) : hotnessURL)
        guard let url = URL(string: finalURL) else {
            print("URL conversion failed")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            self.searchResult = SearchResult()
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                onComplete(self.searchResult.games)
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

// MARK: XMLParserDelegate Methods
extension NetworkManager: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            tempGame = Game()
            tempGame.setId(to: attributeDict["id"] ?? "")
            tempGame.setRank(to: attributeDict["rank"] ?? "")
        } else if elementName == "thumbnail" {
            tempGame.setThumbnailURL(to: attributeDict["value"] ?? "")
        } else if elementName == "name" {
            tempGame.setName(to: attributeDict["value"] ?? "")
        } else if elementName == "yearpublished" {
            tempGame.setYearPublished(to: attributeDict["value"] ?? "")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            searchResult.games.append(tempGame)
        }
    }
}

