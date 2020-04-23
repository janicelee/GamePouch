//
//  Game.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-22.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class Game: NSObject {
    private var id: String?
    private var thumbnailURL: String?
    private var imageURL: String?
    private var name: String?
    private var gameDescription: String?
    private var yearPublished: String?
    private var minPlayers: String?
    private var maxPlayers: String?
    private var playingTime: String?
    private var minAge: String?
    private var categories = [String]()
    private var mechanics = [String]()
    private var rating: String?
    private var rank: String?
    private var weight: String?
    
    // MARK: Getters
    
    func getId() -> String? { return id }
    
    func getThumbnailURL() -> String? { return thumbnailURL }
    
    func getImageURL() -> String? { return imageURL }
    
    func getName() -> String? { return name }
    
    func getGameDescription() -> String? { return gameDescription }
    
    func getYearPublished() -> String? { return yearPublished }
    
    func getMinPlayers() -> String? { return minPlayers }
    
    func getMaxPlayers() -> String? { return maxPlayers }
    
    func getPlayingTime() -> String? { return playingTime }
    
    func getMinAge() -> String? { return minAge }
    
    func getCategories() -> [String] { return categories }
    
    func getCategory(at index: Int) -> String { return categories[index]}
    
    func getMechanics() -> [String] { return mechanics }
    
    func getRating() -> String? { return rating }
    
    func getRank() -> String? { return rank }
    
    func getWeight() -> String? { return weight }
    
    // MARK: Setters
    
    func setId(to id: String?) { self.id = id }
    
    func setThumbnailURL(to urlString: String?) { self.thumbnailURL = urlString }
    
    func setImageURL(to urlString: String?) { self.imageURL = urlString }
    
    func setName(to name: String?) { self.name = name }
    
    func setGameDescription(to description: String?) { self.gameDescription = description }
    
    func setYearPublished(to yearPublished: String?) { self.yearPublished = yearPublished }
    
    func setMinPlayers(to minPlayers: String?) { self.minPlayers = minPlayers }
    
    func setMaxPlayers(to maxPlayers: String?) { self.maxPlayers = maxPlayers }
    
    func setPlayingTime(to playingTime: String?) { self.playingTime = playingTime }
    
    func setMinAge(to minAge: String?) { self.minAge = minAge }

    func addCategory(_ category: String) { self.categories.append(category) }
    
    func addMechanic(_ mechanic: String) { self.mechanics.append(mechanic)}
    
    func setRating(to rating: String?) { self.rating = rating }
    
    func setRank(to rank: String?) { self.rank = rank }
    
    func setWeight(to weight: String?) { self.weight = weight }
}

