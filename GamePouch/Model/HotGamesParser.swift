//
//  SearchResult.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-23.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

class HotGamesParser: NSObject {
    private var tempGame: Game?
    var games = [Game]()
    
    func fromXML(data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension HotGamesParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            tempGame = Game()
            tempGame?.setId(to: attributeDict["id"] ?? "")
            tempGame?.setRank(to: attributeDict["rank"] ?? "")
        } else if elementName == "thumbnail" {
            tempGame?.setThumbnailURL(to: attributeDict["value"] ?? "")
        } else if elementName == "name" {
            tempGame?.setName(to: attributeDict["value"] ?? "")
        } else if elementName == "yearpublished" {
            tempGame?.setYearPublished(to: attributeDict["value"] ?? "")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            games.append(tempGame!)
        }
    }
}
