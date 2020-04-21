//
//  GetGameParser.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-31.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

class GetGameParser: NSObject {
    var game = Game()
    private var foundCharacters = ""
    
    func fromXML(data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension GetGameParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            game.setId(to: attributeDict["id"] ?? "")
        } else if elementName == "name" && attributeDict["type"] == "primary" {
            game.setName(to: attributeDict["value"])
        } else if elementName == "yearpublished" {
            game.setYearPublished(to: attributeDict["value"])
        } else if elementName == "minplayers" {
            game.setMinPlayers(to: attributeDict["value"])
        } else if elementName == "maxplayers" {
            game.setMaxPlayers(to: attributeDict["value"])
        } else if elementName == "playingtime" {
            game.setPlayingTime(to: attributeDict["value"])
        } else if elementName == "minage" {
            game.setMinAge(to: attributeDict["value"])
        } else if elementName == "average" {
            var rating: String?
            if let value = attributeDict["value"], let numValue = Double(value) {
                rating = String(format: "%.1f", numValue)
            }
            game.setRating(to: rating)
        } else if elementName == "rank" && attributeDict["friendlyname"] == "Board Game Rank" {
            game.setRank(to: attributeDict["value"])
        } else if elementName == "averageweight" {
            var weight: String?
            if let value = attributeDict["value"], let numValue = Double(value) {
                weight = String(format: "%.1f", numValue)
            }
            game.setWeight(to: weight)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        foundCharacters = foundCharacters.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if elementName == "thumbnail" {
            game.setThumbnailURL(to: foundCharacters)
        } else if elementName == "image" {
            game.setImageURL(to: foundCharacters)
        } else if elementName == "description" {
            var description = foundCharacters.replacingOccurrences(of: "&#10;&#10;", with: "\n\n")
            description = description.replacingOccurrences(of: "&ldquo;", with: "\"")
            description = description.replacingOccurrences(of: "&rdquo;", with: "\"")
            description = description.replacingOccurrences(of: "&rsquo;", with: "'")
            description = description.replacingOccurrences(of: "&mdash;", with: "-")
            game.setGameDescription(to: description)
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
}
