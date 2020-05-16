//
//  ContentSizedTableView.swift
//  GamePouch
//
//  Created by Janice Lee on 2020-05-15.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
