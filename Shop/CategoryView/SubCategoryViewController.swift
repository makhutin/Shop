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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()

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
        cell.setPicture(picture: UIImage(named: "rick")!)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(data[indexPath.row])
    }

}
