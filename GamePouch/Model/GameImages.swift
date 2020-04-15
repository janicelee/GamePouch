//
//  GameImages.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-04-09.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

struct GameImages: Codable, Hashable {
    let images: [GameImage]
}

struct GameImage: Codable, Hashable {
    let imageurlLg: String
}
