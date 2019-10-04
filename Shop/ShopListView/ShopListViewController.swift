//
//  ShopListViewController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

@IBDesignable
class ShopListViewController: UIViewController, InterfaceIsDark {
    
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    var collectionView: UICollectionView! = nil
    let reuseIdentifier = "cell"
    var data: [ShopItem] = []
    var currentData = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayoutInit()
        collectionInit()
        
        self.view.backgroundColor = intefaceIsDark ? .black : .white
        self.collectionView.backgroundColor = self.view.backgroundColor
        
    }
    
    private func flowLayoutInit() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.view.frame.width / 2 - 20,
                                     height: self.view.frame.height / 2.3)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: self.view.bounds,
        collectionViewLayout: flowLayout )
    }
    
    private func collectionInit() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShopItemViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.reloadData()
    }
    
    private func goToCartItem() {
        let vc = CartItemController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ShopListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count > currentData { return currentData }
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopItemViewCell
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        // Configure the cell
        let cellData = data[indexPath.item]
        
        cell.setName(name: cellData.name)
        cell.setPrice(price: "\(cellData.price!) ₽")
        cell.setPicture(url: cellData.mainImage)

        return cell
    }
    
    func addCell() {
        
    }

    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let cell = collectionView.cellForItem(at: IndexPath(item: indexPath![1], section: indexPath![0])) {
            cell.backgroundColor = .gray
            cell.layer.cornerRadius = cell.frame.width / 16
            UIView.animate(withDuration: 0.2, animations: {
                cell.backgroundColor = .white
            })
        }
        goToCartItem()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y + self.collectionView.frame.height > self.collectionView.contentSize.height + 100 {
            currentData += 8
            if currentData > data.count {
                currentData = data.count
            }
            collectionView.reloadData()
        }
    }
}
