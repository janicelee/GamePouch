//
//  SearchGamesParser.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-05-09.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

class SearchGamesParser: NSObject {
    private var searchResult = SearchResult()
    var searchResults = [SearchResult]()
    
    func fromXML(data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension SearchGamesParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            searchResult = SearchResult()
            searchResult.setId(to:  attributeDict["id"])
        } else if elementName == "name" {
            searchResult.setName(to: attributeDict["value"])
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            searchResults.append(searchResult)
        }
    }
}
