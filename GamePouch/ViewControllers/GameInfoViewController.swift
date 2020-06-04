//
//  GameInfoViewController.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-04-03.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit
import WebKit

class GameInfoViewController: UIViewController {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearPublishedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var mechanicCollectionView: UICollectionView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mechanicCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var game: Game!
    var descriptionExpanded = false
    var galleryImageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
   
        mechanicCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        mechanicCollectionView.delegate = self
        mechanicCollectionView.dataSource = self
        
        //title = game.getName()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NetworkManager.shared.imageCache.removeAllObjects()
    }
    
    func configure() {
        setHeaderImage(fromURL: game.getImageURL())
        nameLabel.text = game.getName()
        yearPublishedLabel.text = game.getYearPublished()
//        ratingLabel.text = "Rating: " + (isValid(game.getRating()) ? game.getRating()! : "N/A")
//        numPlayersLabel.text =
//            "Players: " + (isValid(game.getMinPlayers()) && isValid(game.getMaxPlayers()) ? "\(game.getMinPlayers()!)-\(game.getMaxPlayers()!)" : "N/A")
//        weightLabel.text = "Difficulty: " + (isValid(game.getWeight()) ? "\(game.getWeight()!) /5" : "N/A")
//        rankLabel.text = "Rank: " + (isValid(game.getRank()) ? "\(game.getRank()!)th" : "N/A")
//        playtimeLabel.text = "Time: " + (isValid(game.getPlayingTime()) ? "\(game.getPlayingTime()!)m" : "N/A")
//        minAgeLabel.text = "Age: " + (isValid(game.getMinAge()) ? "\(game.getMinAge()!)+" : "N/A")
        descriptionLabel.text = isValid(game.getGameDescription()) ? game.getGameDescription() : "N/A"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(tapGesture)
        
        downloadGalleryImages()
        configureTagCollectionViews()
    }
    
    func isValid(_ text: String?) -> Bool {
        return text != nil && text != "0" && text != "0.0" && text != "Not Ranked"
    }
    
    func setHeaderImage(fromURL urlString: String?) {
        guard let urlString = urlString else { return }
        
        NetworkManager.shared.downloadImage(from: urlString) { (image) in
            DispatchQueue.main.async {
                let imageHeight = image!.size.height
                let frameHeight = self.view.frame.size.height
                let height =  imageHeight > frameHeight ? (frameHeight / 2) : imageHeight
                
                self.headerImageView.image = image
                self.headerViewHeightConstraint.constant = height
                self.headerImageView.layoutIfNeeded()
            }
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if descriptionExpanded {
            descriptionLabel.numberOfLines = 5
            descriptionLabel.lineBreakMode = .byTruncatingTail
            descriptionExpanded = false
        } else {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            descriptionExpanded = true
        }
    }
    
    func downloadGalleryImages() {
        if let id = game.getId() {
            NetworkManager.shared.getGalleryImageURLs(for: id) { imageURLs in
                self.galleryImageURLs = imageURLs
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
             }
        }
    }
    
    func configureTagCollectionViews() {
        let categoryContentHeight = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        let mechanicContentHeight = mechanicCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        categoryCollectionViewHeightConstraint.constant = categoryContentHeight
        mechanicCollectionViewHeightConstraint.constant = mechanicContentHeight
        
        view.layoutIfNeeded()
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        print("favourite button tapped")
        PersistenceManager.updateWith(favourite: game, actionType: PersistenceActionType.add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                DispatchQueue.main.async {
                    self.favouriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                    print("changing favourite button image")
                }
                return
            }
            // present alert with error message
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return galleryImageURLs.count
        } else if collectionView == categoryCollectionView {
            return game.getNumCategories()
        } else {
            return game.getNumMechanics()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.loadImage(from: galleryImageURLs[indexPath.row])
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.setLabel(to: game.getCategory(at: indexPath.row))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.setLabel(to: game.getMechanic(at: indexPath.row))
            return cell
        }
    }
}

extension GameInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView {
            let numVisibleImages = 2
            let width = collectionView.frame.size.width / CGFloat(numVisibleImages).rounded(.down)
            let height = collectionView.frame.size.height
            return CGSize(width: width, height: height)
        } else if collectionView == categoryCollectionView {
            let text = game.getCategory(at: indexPath.row)
            let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 30
            return CGSize(width: width, height: 30)
        } else {
            let text = game.getMechanic(at: indexPath.row)
            let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 30
            return CGSize(width: width, height: 30)
        }
    }
}
