//
//  CategoryTableViewController.swift
//  Shop
//
//  Created by Mahutin Aleksei on 01/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var data: [Category] = []
    var first: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        data = DataNow.shared.loadCategory()
        data.sort { (elem1, elem2) -> Bool in
            return elem1.sortOrder < elem2.sortOrder
        }
                self.tableView.reloadData()
            

    }
    
    private func goToSubCat(id: Int) {
        let vc = SubCategoryViewController()
        vc.data = DataNow.shared.loadSubCatgory(id: id)
        vc.data.sort { (elem1, elem2) -> Bool in
            return elem1.sortOrder < elem2.sortOrder
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
        cell.setPicture(url: rowData.iconImage)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToSubCat(id: data[indexPath.row].id)
    }
    
}
