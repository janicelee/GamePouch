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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearPublishedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var headerImageViewHeightConstraint: NSLayoutConstraint!
    
    var game: Game!
    var descriptionExpanded = false
    var galleryImageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        //title = game.getName()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NetworkManager.shared.imageCache.removeAllObjects()
    }
    
    func configure() {
        setHeaderImage(fromURL: game.getImageURL())
        downloadGalleryImages()
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
                self.headerImageViewHeightConstraint.constant = height
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
}

// MARK: - UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return galleryImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.loadImage(from: galleryImageURLs[indexPath.row])
        return cell
    }
}

extension GameInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numVisibleImages = 2
//        let spacing = 2
//        let emptySpace = CGFloat((numVisibleImages - 1) * spacing)
        let width = collectionView.frame.size.width / CGFloat(numVisibleImages).rounded(.down)
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
