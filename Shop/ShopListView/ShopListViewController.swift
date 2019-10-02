//
//  ShopListViewController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

@IBDesignable
class ShopListViewController: UIViewController {
    
    var collectionView: UICollectionView! = nil
    let reuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayoutInit()
        collectionInit()
        
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func flowLayoutInit() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.view.frame.width / 2 - 20,
                                     height: self.view.frame.height / 3)
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


    

}

extension ShopListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopItemViewCell
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        // Configure the cell
        cell.setName(name: "test")
        cell.setPrice(price: "999")
        cell.setImage(image: UIImage(named: "rick")!)

        return cell
    }

    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let cell = collectionView.cellForItem(at: IndexPath(item: indexPath![1], section: indexPath![0]))
        cell?.backgroundColor = .gray
       
        if let index = indexPath {
          print("Got clicked on index: \(index)!")
        }
    }
    
    
}
