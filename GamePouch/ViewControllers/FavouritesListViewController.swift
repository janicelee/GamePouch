//
//  FavouritesListViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-05-26.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit
import CoreData

class FavouritesListViewController: UITableViewController {
    var favourites: [NSManagedObject] = []
    var selectedGame: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GameInfoCell", bundle: nil), forCellReuseIdentifier: "GameInfoCell")
        configureViewController()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        
        do {
            favourites = try managedContext.fetch(fetchRequest).reversed()
            updateUI()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favourites"
    }
    
    func updateUI() {
        if favourites.isEmpty {
            // show empty state
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameInfoViewController = segue.destination as? GameInfoViewController {
            gameInfoViewController.game = selectedGame
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameInfoCell.reuseID, for: indexPath) as! GameInfoCell
        if let id = favourites[indexPath.row].value(forKeyPath: "id") as? String {
            NetworkManager.shared.getGame(id: id) { game in
                DispatchQueue.main.async {
                        cell.setGame(to: game)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameInfoCell
        if  let game = cell.getGame() {
            selectedGame = game
            performSegue(withIdentifier: "showFavouriteGameInfo", sender: self)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
