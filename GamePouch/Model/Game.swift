//
//  Game.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-22.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class Game {
    private var id: String = ""
    private var name: String = ""
    private var yearPublished: String = ""
    private var image: UIImage?
    
    func getId() -> String {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getYearPublished() -> String {
        return yearPublished
    }
    
    func setId(to id: String) {
        self.id = id
    }
    
    func setName(to name: String) {
        self.name = name
    }
    
    func setYearPublished(to yearPublished: String) {
        self.yearPublished = yearPublished
    }
}

