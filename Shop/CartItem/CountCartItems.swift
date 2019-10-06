//
//  CountCartItems.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class CountCartItems: UIView {

    private var label = UILabel()
    private let pic = UIImageView(image: UIImage(named: "BuyButton"))
    private let corner = UIView()
    
    override func didMoveToSuperview() {
        self.addSubview(pic)
        self.addSubview(corner)
        corner.addSubview(label)
        for elem in [pic,corner,label] {
            elem.translatesAutoresizingMaskIntoConstraints = false
        }
        
        pic.contentMode = .scaleToFill
        corner.backgroundColor = .red
        corner.layer.cornerRadius = 14 / 2
        self.addSubview(label)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pic.topAnchor.constraint(equalTo: self.topAnchor, constant: -7),
            pic.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pic.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            pic.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            //
            corner.widthAnchor.constraint(equalToConstant: 14),
            corner.heightAnchor.constraint(equalToConstant: 14),
            corner.centerXAnchor.constraint(equalTo: pic.trailingAnchor),
            corner.centerYAnchor.constraint(equalTo: pic.topAnchor),
            //
            label.topAnchor.constraint(equalTo: corner.topAnchor),
            label.trailingAnchor.constraint(equalTo: corner.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: corner.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: corner.leadingAnchor),
        ])
    }
    func updateLabel(number: Int) {
        self.layer.cornerRadius = self.frame.width / 4
        label.text = "\(number)"
        label.sizeToFit()
        label.layoutIfNeeded()
    }
}

