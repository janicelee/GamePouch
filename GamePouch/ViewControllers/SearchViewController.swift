//
//  SearchViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-25.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var gameInfoTableView: UITableView!
    private var searchSuggestionsTableView = UITableView()
    
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    private var hotGames: [Game] = []
    private var searchSuggestions: [Game] = []
    private var maxNumSuggestions = 8
    private var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    private var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Hot Games"
        
        setUpSearchSuggestionsTableView()
        
        gameInfoTableView.delegate = self
        gameInfoTableView.dataSource = self
        
        searchController.searchResultsUpdater = self // inform this class of any text changes within UISearchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a game"
        navigationItem.searchController = searchController // adds searchBar to navigationItem
        definesPresentationContext = true // ensures search bar doesn't stay on screen if user navigates to another viewcontroller while UISearchController is active
        
        networkManager.getHotnessList(type: SearchType.hotness, onComplete: setGames)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = gameInfoTableView.indexPathForSelectedRow {
            gameInfoTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func setUpSearchSuggestionsTableView() {
        view.addSubview(searchSuggestionsTableView)
        
        searchSuggestionsTableView.delegate = self
        searchSuggestionsTableView.dataSource = self
        
        searchSuggestionsTableView.backgroundColor = UIColor.green
        searchSuggestionsTableView.isHidden = true
        searchSuggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchSuggestionCell")
        searchSuggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchSuggestionsTableView.topAnchor.constraint(equalTo: gameInfoTableView.topAnchor),
            searchSuggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchSuggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchSuggestionsTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func setGames(_ games: [Game]) {
        self.hotGames = games
        DispatchQueue.main.async {
            self.gameInfoTableView.reloadData()
        }
    }
    
    func getSearchResults(for searchText: String) {
        networkManager.search(for: searchText) { searchText, games in
            DispatchQueue.main.async {
                if searchText == self.searchController.searchBar.text {
                    self.searchSuggestions = games
                    self.searchSuggestionsTableView.isHidden = false
                    self.searchSuggestionsTableView.reloadData()
                }
            }

        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchSuggestionsTableView {
            return searchSuggestions.count > maxNumSuggestions ? maxNumSuggestions : searchSuggestions.count
        } else {
            return hotGames.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchSuggestionsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchSuggestionCell", for: indexPath)
            cell.textLabel?.text = searchSuggestions[indexPath.row].getName()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GameInfoCell.reuseID, for: indexPath) as! GameInfoCell
            let game = isFiltering ? searchSuggestions[indexPath.row] : hotGames[indexPath.row]
            cell.setGame(to: game)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = hotGames[indexPath.row]
        
        if let gameInfoViewController = storyboard?.instantiateViewController(withIdentifier: "GameInfoViewController") as? GameInfoViewController {
            gameInfoViewController.game = selectedGame
            navigationController?.pushViewController(gameInfoViewController, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        if searchText?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            getSearchResults(for: searchText!)
        } else {
            searchSuggestionsTableView.isHidden = true
        }
    }
}
