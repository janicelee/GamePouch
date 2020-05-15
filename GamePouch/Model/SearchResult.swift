//
//  SearchResult.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-05-15.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

struct SearchResult {
    private var id: String?
    private var name: String?
    
    func getId() -> String? {
        return self.id
    }
    
    func getName() -> String? {
        return self.name
    }
    
    mutating func setId(to id: String?) {
        self.id = id
    }
    
    mutating func setName(to name: String?) {
        self.name = name
    }
}
