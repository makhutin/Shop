//
//  CartViewController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class CartViewController: UIViewController,InterfaceIsDark {
    
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    private let delAlert = UIView()
    private let sumPrice = UIStackView()
    private let price = UILabel()
    private let priceLabel = UILabel()
    private let buyAllItems = UIButton()
    private let lineGray = UIView()
    private let itemList = UITableView()
    private let backgroundForSizeView = UIView()
    private let tableView = UITableView()
    private let dellAll = UIButton()
    private let delView = DelView()
    
    var delId = 0
    var all = false
    
    var data = DataNow.shared.cartItem
    
    var priceData = 0
    

    override func viewDidLoad() {
        self.view.backgroundColor = intefaceIsDark ? .black : .white
        
        super.viewDidLoad()
        buttonInit()
        lineInit()
        priceInit()
        tableInit()
        delAllInit()
        constraintInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        uploadData()
        self.navigationController?.isNavigationBarHidden = false
        let button = UIBarButtonItem(image: UIImage(named: "delAll"), style: .done, target: self, action: #selector(delAll))
        if let done = self.navigationController?.navigationBar.topItem {
            done.title = "Корзина"
            done.leftBarButtonItem = button
            done.leftItemsSupplementBackButton = false
            done.hidesBackButton = true
        }
    }
    
    @objc func delAll() {
        delView.style(deleteAll: true)
        goDeleteAlert()
        all = true
    }
    
    private func uploadData() {
        DataNow.shared.loadCartItems()
        data = DataNow.shared.cartItem
        priceData = 0
        for elem in data {
            priceData += elem.price
        }
        tableView.reloadData()
        
        if priceData > 0 {
            buyAllItems.frame.size = CGSize(width: buyAllItems.frame.width, height: 48)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.isEnabled = true
        }else{
            buyAllItems.frame.size = CGSize(width: buyAllItems.frame.width, height: 0)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.isEnabled = false
        }
        price.text = String(priceData) + " руб."
        
    }
    
    
    private func constraintInit() {
        NSLayoutConstraint.activate([
            //buyAllItems
            buyAllItems.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -47 + -(tabBarController?.tabBar.frame.size.height ?? 0)),
            buyAllItems.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            buyAllItems.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            //lineGray
            lineGray.bottomAnchor.constraint(equalTo: buyAllItems.topAnchor, constant: -36),
            lineGray.heightAnchor.constraint(equalToConstant: 1),
            lineGray.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            lineGray.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            //sumPrice
            sumPrice.bottomAnchor.constraint(equalTo: lineGray.topAnchor, constant: -24),
            sumPrice.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            sumPrice.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            sumPrice.heightAnchor.constraint(equalToConstant: 64),
            //table
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sumPrice.topAnchor),
            //dellAll
            dellAll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -31),
            dellAll.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            dellAll.widthAnchor.constraint(equalToConstant: 14),
            dellAll.heightAnchor.constraint(equalToConstant: 14),
            
        ])
    }
    
    
    private func delAllInit() {
        view.addSubview(dellAll)
        dellAll.translatesAutoresizingMaskIntoConstraints = false
        dellAll.setImage(UIImage(named: "delAll"), for: .normal)
        dellAll.addTarget(self, action: #selector(delAll), for: .touchUpInside)
    }
    
    private func tableInit() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func buttonInit() {
        view.addSubview(buyAllItems)
        buyAllItems.translatesAutoresizingMaskIntoConstraints = false
        buyAllItems.addTarget(self, action: #selector(buyAll), for: .touchUpInside)
        buyAllItems.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        buyAllItems.setTitle("Оформить заказ", for: .normal)
        buyAllItems.frame.size = CGSize(width: buyAllItems.frame.width, height: 0)
        buyAllItems.layer.cornerRadius = 48 / 4
    }
    
    private func priceInit() {
        view.addSubview(sumPrice)
        sumPrice.translatesAutoresizingMaskIntoConstraints = false
        sumPrice.addArrangedSubview(priceLabel)
        sumPrice.addArrangedSubview(price)
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.text = "Итого:"
        price.font = UIFont.systemFont(ofSize: 16)
        price.text = String(priceData) + " руб."
        price.textColor = price.textColor.withAlphaComponent(0.5)
        sumPrice.axis = .horizontal
        sumPrice.alignment = .fill
        sumPrice.distribution = .equalSpacing
    }
    
    private func lineInit() {
        view.addSubview(lineGray)
        lineGray.translatesAutoresizingMaskIntoConstraints = false
        lineGray.backgroundColor = .gray
    }
    
    @objc private func buyAll() {
        DataNow.shared.deleteAllItemsFromCart()
        uploadData()
    }
    
    func goDeleteAlert() {
        self.view.addSubview(backgroundForSizeView)
        backgroundForSizeView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        backgroundForSizeView.layer.opacity = 0
        self.view.addSubview(delView)
        delView.layer.opacity = 1
        delView.delegate = self
        backgroundForSizeView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        delView.frame.size = CGSize(width: UIScreen.main.bounds.width - 32, height: 218)
        delView.frame.origin = CGPoint(x: 16, y: UIScreen.main.bounds.height)
        delView.layer.cornerRadius = delView.frame.width / 16
        delView.backgroundColor = intefaceIsDark ? .black : .white
        UIView.animate(withDuration: 0.3, animations: {
            self.delView.frame.origin = CGPoint(x: 16, y: UIScreen.main.bounds.height / 4)
            self.backgroundForSizeView.layer.opacity = 1
        }, completion: {
            complete in
            self.delView.frame.origin = CGPoint(x: 16, y: UIScreen.main.bounds.height / 4)
            self.backgroundForSizeView.layer.opacity = 1
        })
    }
    
    func stopDelAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.delView.layer.opacity = 0
            self.backgroundForSizeView.layer.opacity = 0
            
        }, completion: {
            complete in
            self.delView.removeFromSuperview()
            self.backgroundForSizeView.removeFromSuperview()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopDelAlert()
    }
}

extension CartViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemInCartCell()
        let rowData = data[indexPath.row]
        cell.start()
        DataLoader.shared.loadShopItems(id: Int(rowData.subId) ?? 0, complete: {
            let data = DataNow.shared.loadShopList().filter { return $0.id == rowData.id }
            if let data = data.first {
                let price: Int = (data.price ?? 0)
                cell.delegate = self
                cell.id = rowData.buyId
                cell.setup(price: "\(price)" , size: rowData.size, name: data.name, picUrl: rowData.imageUrl, id: rowData.buyId)
                cell.stop()
            }
        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    
    
    
}

extension CartViewController: ItemInCartCellDelegate {
    func delitem(cell: ItemInCartCell) {
        delId = cell.id
        goDeleteAlert()
        delView.style(deleteAll: false)
    }
}

extension CartViewController: DelViewDelegate {
    func pressYes() {
        if all {
            DataNow.shared.deleteAllItemsFromCart()
            uploadData()
            all = false
            stopDelAlert()
        }else{
            DataNow.shared.deleteItemFromCart(buyId: delId)
            uploadData()
            stopDelAlert()
        }
    }
    
    func pressNo() {
        stopDelAlert()
    }
    
    
}
