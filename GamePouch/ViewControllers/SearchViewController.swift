//
//  SearchViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-03-25.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var gameInfoTableView: ContentSizedTableView!
    private var searchSuggestionsTableView = UITableView()
    
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var hotGames: [Game] = []
    private var lastSearchText : String?
    private var searchSuggestions: [SearchResult] = []
    private var maxNumSuggestions = 8
    private var suggestedGameSelected: Bool = false
    private var suggestedGame: Game?
    private var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    private var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty}
    private var debouncedSearch: (() -> Void)?
    
    private var searchSuggestionsTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Hot Games"
        
        debouncedSearch = debounce(interval: 200) {
            self.getSearchResults(for: self.lastSearchText!)
        }
        setUpSearchSuggestionsTableView()
        
        gameInfoTableView.register(UINib(nibName: "GameInfoCell", bundle: nil), forCellReuseIdentifier: "GameInfoCell")
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
        suggestedGameSelected = false
        suggestedGame = nil
        
        if let gameInfoTableViewSelectedPath = gameInfoTableView.indexPathForSelectedRow {
            gameInfoTableView.deselectRow(at: gameInfoTableViewSelectedPath, animated: animated)
        }
        if let searchSuggestionsTableViewSelectedPath = searchSuggestionsTableView.indexPathForSelectedRow {
            searchSuggestionsTableView.deselectRow(at: searchSuggestionsTableViewSelectedPath, animated: animated)
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
        
        searchSuggestionsTableViewHeightConstraint = searchSuggestionsTableView.heightAnchor.constraint(equalToConstant: 200)
        
        
        NSLayoutConstraint.activate([
            searchSuggestionsTableView.topAnchor.constraint(equalTo: gameInfoTableView.topAnchor),
            searchSuggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchSuggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchSuggestionsTableViewHeightConstraint
        ])
    }
    
    func setGames(_ games: [Game]) {
        self.hotGames = games
        DispatchQueue.main.async {
            self.gameInfoTableView.reloadData()
        }
    }
    
    func getSearchResults(for searchText: String) {
        print("Searching for " + searchText)
        networkManager.search(for: searchText) { searchText, searchResults in
            if searchText == self.lastSearchText {
                self.searchSuggestions = searchResults
                print("Results received for " + searchText)
                DispatchQueue.main.async {
                    self.searchSuggestionsTableView.isHidden = false
                    self.searchSuggestionsTableView.reloadData()

                    let contentHeight = self.searchSuggestionsTableView.contentSize.height
                    self.searchSuggestionsTableViewHeightConstraint.constant = contentHeight
                    self.searchSuggestionsTableView.updateConstraints()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = suggestedGameSelected ? searchSuggestionsTableView.indexPathForSelectedRow : gameInfoTableView.indexPathForSelectedRow else { return }
        if let gameInfoViewController = segue.destination as? GameInfoViewController {
            gameInfoViewController.game = suggestedGameSelected ? suggestedGame : hotGames[selectedPath.row]
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
            cell.setGame(to: hotGames[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchSuggestionsTableView {
            guard let searchResultId = searchSuggestions[indexPath.row].getId() else { return }
            suggestedGameSelected = true
            
            networkManager.getGame(id: searchResultId) { game in
                self.suggestedGame = game
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showGameInfo", sender: self)
                }
            }
        } else {
            self.performSegue(withIdentifier: "showGameInfo", sender: self)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text

        if searchText?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            lastSearchText = searchText
            debouncedSearch!()
        } else {
            searchSuggestionsTableView.isHidden = true
        }
    }
}
