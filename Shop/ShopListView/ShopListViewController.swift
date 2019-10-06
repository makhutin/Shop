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
    private var sizeView = SizeView()
    private let backgroundForSizeView = UIView()
    var currentPressIndex = 0
    var idCat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayoutInit()
        collectionInit()
        
        self.view.backgroundColor = intefaceIsDark ? .black : .white
        self.collectionView.backgroundColor = self.view.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
    
    private func goToCartItem(sender: ShopItemViewCell) {
        let vc = CartItemController()
        let itemData = data[sender.selfIndex]
        vc.nameData = itemData.name
        vc.priceData = String(itemData.price!)
        vc.piceIntData = itemData.price!
        vc.descriptionData = itemData.description
        vc.imageUrl = itemData.productImages
        vc.sizeDataForItem = itemData.offers
        vc.id = itemData.id
        vc.subId = idCat

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.sizeView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self.backgroundForSizeView.layer.opacity = 0
            self.backgroundForSizeView.layoutIfNeeded()
        }, completion: { comlition in
            self.backgroundForSizeView.removeFromSuperview()
            self.sizeView.removeFromSuperview()
        })
        
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
        
        cell.delegate = self
        cell.selfIndex = indexPath.item
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
                cell.backgroundColor = self.intefaceIsDark ? .black : .white
            })
            goToCartItem(sender: cell as! ShopItemViewCell)
        }
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

extension ShopListViewController: SizeViewDelegate {
    func sizeIsChoice(size: [String : String]) {
        DataNow.shared.saveCartItem(imageUrl: data[currentPressIndex].mainImage,
                                    buyId: Int(size["productOfferID"] ?? "") ?? 0,
                                    id: data[currentPressIndex].id,
                                    size: size["size"] ?? "",
                                    subId: String(idCat),
                                    price: data[currentPressIndex].price ?? 0)
        DataNow.shared.loadCartItems()
        UIView.animate(withDuration: 0.3, animations: {
            self.sizeView.frame.origin = CGPoint(x: self.sizeView.frame.width, y: -self.sizeView.frame.height)
            self.backgroundForSizeView.layer.opacity = 0
            self.backgroundForSizeView.layoutIfNeeded()
        }, completion: { comlition in
            self.backgroundForSizeView.removeFromSuperview()
            self.sizeView.removeFromSuperview()
        })
    }
    
    
}

extension ShopListViewController: ShopItemViewCellDelegate {
    func pressBuy(index: Int) {
        buyItem(index: index)
    }
    
    private func buyItem(index: Int) {
        let view = backgroundForSizeView
        sizeView = SizeView()
        self.backgroundForSizeView.layer.opacity = 0
        view.frame = self.view.frame
        let color: UIColor = (intefaceIsDark ? .white : .black)
        view.backgroundColor = color.withAlphaComponent(0.5)
        self.view.addSubview(view)
        let itemData = data[index]
        sizeView.sizeData = itemData.offers
        sizeView.delegate = self
        sizeView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        sizeView.loadSizes()
        sizeView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: sizeView.frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundForSizeView.layer.opacity = 1
            self.sizeView.frame.origin = CGPoint(x: 0, y: self.view.frame.height - self.sizeView.frame.height)
        })
        view.addSubview(sizeView)
    }
    
    
    
    
}
