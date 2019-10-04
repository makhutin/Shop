//
//  ShopItemViewCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class ShopItemViewCell: UICollectionViewCell, InterfaceIsDark {
    
    private let pic = ImageShopItemCell()
    private let name = UILabel()
    private let price = UILabel()
    private let button = UIButton()
    private let indicator = UIActivityIndicatorView()
    
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    override func didMoveToSuperview() {
        
        indicator.stopAnimating()

        for elem in [name,pic,price,button,indicator] {
            addSubview(elem)
            elem.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        constraintsInit()
        buttonInit()
        nameInit()
        priceInit()
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
            indicator.centerXAnchor.constraint(equalTo: pic.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: pic.centerYAnchor),
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
    
    
    private func buttonInit() {
        button.setTitle("купить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto", size: 8)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(displayP3Red: 247/255, green: 60/255, blue: 104/255, alpha: 0.85)
    }
    
    private func nameInit() {
        name.font = UIFont.systemFont(ofSize: 11)
        name.numberOfLines = 2
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.5
        name.textColor = UIColor(displayP3Red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        if intefaceIsDark {
            name.textColor = UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    private func priceInit() {
        price.adjustsFontSizeToFitWidth = true
        price.minimumScaleFactor = 0.5
        price.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func setPrice(price: String) {
        self.price.text = price
        self.price.layoutIfNeeded()
    }
    
    func setName(name: String) {
        self.name.text = name
        self.name.layoutIfNeeded()
    }
    
    
    func setPicture(url: String) {
        pic.isHidden = true
        indicator.startAnimating()
        //try load from realm
        if let oldImage = PersistanceData.shared.loadImage(url: url) {
            self.indicator.stopAnimating()
            self.pic.picView.image = oldImage
            setupPic()
            return
        }
        
        //try load from network
        DataLoader.shared.getImageFromWeb(DataNow.shared.url + url, closure: {
            image in
            if image != nil {
                self.pic.picView.image = image!
                PersistanceData.shared.saveImage(image: image!, url: url)
            }else{
                self.pic.picView.image = UIImage(named: "NoImg")
                PersistanceData.shared.saveFailData(url: url)
            }
            self.setupPic()
        })
    }
    
    private func setupPic() {
        self.pic.isHidden = false
        self.indicator.stopAnimating()
        self.pic.clipsToBounds = true
        self.pic.layoutIfNeeded()
        self.pic.layer.shouldRasterize = true
        self.pic.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
}



