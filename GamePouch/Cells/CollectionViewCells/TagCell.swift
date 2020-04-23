//
//  TagCell.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-04-21.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    
    func setLabel(to title: String) {
        tagLabel.text = title
        tagLabel.layer.cornerRadius = 12
    }
}
