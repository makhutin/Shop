//
//  CartitemCell.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

protocol ItemInCartCellDelegate {
    func delitem(cell: ItemInCartCell)
}

class ItemInCartCell: UITableViewCell, InterfaceIsDark {
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    
    private let pic = ImageShopItemCell()
    private let name = UILabel()
    private let size = UILabel()
    private let price = UILabel()
    private let del = UIButton()
    private let indicator = UIActivityIndicatorView()
    private let indicator2 = UIActivityIndicatorView()
    var id = 0
    
    var delegate: ItemInCartCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func didMoveToSuperview() {
        pic.contentMode = .scaleAspectFit
        for elem in [pic,name,size,price,del,indicator,indicator2] {
            self.contentView.addSubview(elem)
            elem.translatesAutoresizingMaskIntoConstraints = false
        }
        textInit()
        constraintInit()
        del.setImage(UIImage(named: "del"), for: .normal)
        del.addTarget(self, action: #selector(pressDel), for: .touchUpInside)
    }

    func constraintInit() {
        NSLayoutConstraint.activate([
            //pic
            pic.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            pic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 7),
            pic.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            pic.widthAnchor.constraint(equalTo: pic.heightAnchor),
            //name
            name.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
            //size
            size.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            size.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 10),
            size.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
            //price
            price.topAnchor.constraint(equalTo: size.bottomAnchor, constant: -8),
            price.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -9),
            price.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 10),
            price.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
            //buy
            del.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            del.widthAnchor.constraint(equalToConstant: 36),
            del.heightAnchor.constraint(equalToConstant: 36),
            del.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            //indicator
            indicator.centerXAnchor.constraint(equalTo: pic.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: pic.centerYAnchor),
            //indicator2
            indicator2.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            indicator2.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
        ])
    }
    
    private func textInit() {
        name.font = UIFont.systemFont(ofSize: 16)
        size.font = UIFont.systemFont(ofSize: 11)
        price.font = UIFont.systemFont(ofSize: 15)
        for elem in [name,size,price] {
            elem.textAlignment = .left
        }
        let color: UIColor = (intefaceIsDark ? .white : .black)
        size.textColor = color.withAlphaComponent(0.5)
    }
    
    func setup(price: String, size: String, name: String, picUrl: String, id: Int) {
        self.price.text = price + " руб."
        if price.count > 3 {
            let end = price.reversed()[0...2].reversed()
            let startIndex = price.index(price.startIndex, offsetBy: 0)
            let endIndex = price.index(price.startIndex, offsetBy: price.count - 4)
            let start = price[startIndex...endIndex]
            self.price.text = start + " " + end + " руб."
                   }
        
        self.size.text = "Размер: " + size
        self.name.text = name
        self.price.layoutIfNeeded()
        self.size.layoutIfNeeded()
        self.name.layoutIfNeeded()
        self.id = id
        setPicture(url: picUrl)
    }
    
    func stop() {
        indicator2.stopAnimating()
        indicator2.isHidden = true
    }
    
    func start() {
        indicator2.startAnimating()
        indicator2.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
    @objc private func pressDel() {
        delegate?.delitem(cell: self)
    }
    
    private func setPicture(url: String) {
        pic.clipsToBounds = true
        indicator.isHidden = false
        indicator.startAnimating()
        //try load from realm
        if let oldImage = PersistanceData.shared.loadImage(url: url) {
            self.indicator.stopAnimating()
            self.pic.picView.image = oldImage
            self.pic.layoutIfNeeded()
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
            self.indicator.stopAnimating()
            self.pic.layoutIfNeeded()
        })
    }

}
