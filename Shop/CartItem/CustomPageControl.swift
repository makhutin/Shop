//
//  CustomPageControl.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class CustomPageControl: UIPageControl {

override var numberOfPages: Int {
    didSet {
        updateDots()
    }
}

override var currentPage: Int {
    didSet {
        updateDots()
    }
}

override func awakeFromNib() {
    super.awakeFromNib()
    let noneColor = UIColor.white.withAlphaComponent(0)
    pageIndicatorTintColor = noneColor
    currentPageIndicatorTintColor = noneColor
    clipsToBounds = false
}

private func updateDots() {
    for (index, subview) in subviews.enumerated() {
        let color = UIColor.white.withAlphaComponent(0.7).cgColor
        subview.layer.borderColor = color
        if currentPage == index {
            subview.layer.borderWidth = 0
        }else{
            subview.layer.borderWidth = 1
        }
    }
}

}
