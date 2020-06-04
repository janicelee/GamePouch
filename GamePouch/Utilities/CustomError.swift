//
//  CustomError.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-06-03.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

enum CustomError: String, Error {
    case unableToFavourite = "There was an error. Please try again."
    case alreadyInFavourites = "This user is already in your favourites."
}
