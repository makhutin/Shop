//
//  SubCategoryViewController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class SubCategoryViewController: UITableViewController {
    
    var data: [SubCategory] = []
    var id: Int = 0
    var nameCategory: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()

    }
    
    private func goToItems(id: Int,complite: @escaping () -> Void ) {
        DataNow.shared.clearShopList()
        let vc = ShopListViewController()
        DataLoader.shared.loadShopItems(id: id, complete: {
            vc.data = DataNow.shared.loadShopList()
            vc.data.sort { (elem1, elem2) -> Bool in
                return elem1.sortOrder < elem2.sortOrder
            }
            self.navigationController?.pushViewController(vc, animated: true)
            complite()
        })
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count > 0 ? data.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryTableViewCell()
        if data.count == 0 {
            return cell
        }
        let rowData = data[indexPath.row]
        cell.setText(text: rowData.name)
        cell.setPicture(url: rowData.iconImage )


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.isUserInteractionEnabled = false
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
            cell.load(isLoad: true)
            goToItems(id: data[indexPath.row].idToSite,complite: {
                cell.load(isLoad: false)
                self.tableView.isUserInteractionEnabled = true
            })
        }

    }

}
