//
//  ShopItemViewCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class ShopItemViewCell: UICollectionViewCell {
    
    private let pic = UIImageView()
    private let name = UILabel()
    private let price = UILabel()
    private let button = UIButton()
    
    override func didMoveToSuperview() {
        for elem in [name,pic,price,button] {
            addSubview(elem)
            elem.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        constraintsInit()
        buttonInit()
        nameInit()
        priceInit()
        picInit()
    }
    
    private func constraintsInit() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            name.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8),
            name.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 8),
            name.bottomAnchor.constraint(equalTo: pic.topAnchor, constant: -4),
            pic.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pic.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pic.heightAnchor.constraint(equalTo: pic.widthAnchor),
            button.topAnchor.constraint(equalTo: pic.bottomAnchor, constant: 4),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7),
            button.widthAnchor.constraint(equalToConstant: 70),
            price.topAnchor.constraint(equalTo: pic.bottomAnchor, constant: 8),
            price.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            price.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            price.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    private func picInit() {
        pic.contentMode = .scaleAspectFit
    }
    
    private func buttonInit() {
        button.setTitle("купить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto", size: 8)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(displayP3Red: 247/255, green: 60/255, blue: 104/255, alpha: 0.85)
    }
    
    private func nameInit() {
        name.font = UIFont(name: "Sf-pro", size: 11)
        name.textColor = UIColor(displayP3Red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
    }
    
    private func priceInit() {
        price.font = UIFont(name: "Sf-pro", size: 16)
    }
    
    func setPrice(price: String) {
        self.price.text = price
        self.price.layoutIfNeeded()
    }
    
    func setName(name: String) {
        self.name.text = name
        self.name.layoutIfNeeded()
    }
    
    func setImage(image: UIImage) {
        pic.image = image
        pic.layoutIfNeeded()
    }
    
    
}
