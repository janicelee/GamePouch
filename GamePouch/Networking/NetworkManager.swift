//
//  NetworkManager.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-20.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    //private let baseURL = "https://www.boardgamegeek.com/xmlapi2/boardgame"
    private let baseURL = "https://www.boardgamegeek.com/xmlapi/search?search=Mansions"
    
    private var searchResult = SearchResult()
    private var tempGame = Game()
    private var contentBuffer = String()
    
    
    private override init() {}
    
    func searchForGames(_ onComplete: @escaping ([Game]) -> ()) {
        guard let url = URL(string: baseURL) else {
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
}

// MARK: XMLParserDelegate Methods
extension NetworkManager: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "boardgame" {
            tempGame = Game()
            tempGame.setId(to: attributeDict["objectid"] ?? "")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "name" {
            tempGame.setName(to: contentBuffer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        } else if elementName == "yearpublished" {
            tempGame.setYearPublished(to: contentBuffer.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        } else if elementName == "boardgame" {
            searchResult.games.append(tempGame)
        }
        contentBuffer = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        contentBuffer += string
    }
}

