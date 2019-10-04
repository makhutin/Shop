//
//  ImageShopItemCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 04/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class ImageShopItemCell: UIView {

    var picView = UIImageView()
    
    
    override func didMoveToSuperview() {
        self.addSubview(picView)
        picView.translatesAutoresizingMaskIntoConstraints = false
        picView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            picView.topAnchor.constraint(equalTo: self.topAnchor),
            picView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            picView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 50)
        ])
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
