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
        data = []
        let tempData = PersistanceData.shared.loadCategory()
        for elem in tempData {
            let cat = Category()
            cat.iconImage = elem.iconImage
            cat.id = elem.id
            cat.name = elem.name
            cat.sortOrder = elem.sortOrder
            data.append(cat)
        }
        data.sort { (elem1, elem2) -> Bool in
            return elem1.sortOrder < elem2.sortOrder
        }
        
                self.tableView.reloadData()
            

    }
    
    private func goToSubCat(id: Int) {
        let vc = SubCategoryViewController()
        let data = PersistanceData.shared.loadSubCategory(id: id)
        vc.data = []
        for elem in data {
            let sub = SubCategory()
            sub.iconImage = elem.iconImage
            sub.id = elem.id
            sub.idToSite = elem.idToSite
            sub.name = elem.name
            sub.sortOrder = elem.sortOrder
            vc.data.append(sub)
        }
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
//        cell.picture.image = UIImage(named: "rick")
        let rowData = data[indexPath.row]
        
        cell.setText(text: rowData.name)
        cell.setPicture(picture: UIImage(named: "rick")!)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToSubCat(id: data[indexPath.row].id)
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
