//
//  PersistenceManager.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-06-03.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func updateWith(favourite: Game, actionType: PersistenceActionType, completed: @escaping (CustomError?) -> ()) {
        retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completed(.alreadyInFavourites)
                        return
                    }
                    favourites.append(favourite)
                case .remove:
                    favourites.removeAll { $0.id == favourite.id }
                }
                completed(save(favourites: favourites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavourites(completed: @escaping (Result<[Game], CustomError>) -> ()) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Game].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToFavourite))
        }
    }
    
    static func save(favourites: [Game]) -> CustomError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
