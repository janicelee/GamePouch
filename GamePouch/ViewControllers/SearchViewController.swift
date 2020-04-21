//
//  SearchViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-25.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var games: [Game] = []
    private var filteredGames: [Game] = []
    private var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    private var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Hot Games"
        
        searchController.searchResultsUpdater = self // inform this class of any text changes within UISearchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a game"
        navigationItem.searchController = searchController // adds searchBar to navigationItem
        definesPresentationContext = true // ensures search bar doesn't stay on screen if user navigates to another viewcontroller while UISearchController is active
        
        networkManager.getHotnessList(type: SearchType.hotness, onComplete: setGames)
        //networkManager.downloadImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func setGames(_ games: [Game]) {
        self.games = games
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredGames = games.filter { (game: Game) -> Bool in
        return (game.getName()?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGames.count
        } else {
            return games.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameInfoCell.reuseID, for: indexPath) as! GameInfoCell
        let game = isFiltering ? filteredGames[indexPath.row] : games[indexPath.row]
        cell.setGame(to: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        
        if let gameInfoViewController = storyboard?.instantiateViewController(withIdentifier: "GameInfoViewController") as? GameInfoViewController {
            gameInfoViewController.game = selectedGame
            navigationController?.pushViewController(gameInfoViewController, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
