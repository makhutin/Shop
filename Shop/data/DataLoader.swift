//
//  DataLoader.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import Foundation
import Alamofire


/**
Load data from internet and sent to (PersistanceData is Realm)
*/
class DataLoader {
    
    static let shared = DataLoader()
    
    func loadCategory( complete:@escaping (_ new: Bool) -> Void) {
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            response in
            if response.result.isSuccess {
                if self.isNew(count: response.result.debugDescription.count) {
                    complete(false)
                }else{
                    guard let jsonDict = response.result.value as? NSDictionary
                    else { return }
                    for (key,value) in jsonDict {
                            let id = Int(key as! String)!
                        guard let jsonCategory = value as? NSDictionary else { return }
                        self.sendCategory(category: jsonCategory, id: id)
                    }
                }
                self.saveCount(count: response.result.debugDescription.count)
                complete(true)
                }
                
            })
                
        }
    
}

//send data to Persistance class (realm)
extension DataLoader {

    private func saveCount(count: Int) {
        PersistanceData.shared.saveCategoryDataCount(count: count)
    }
    
    
    private func isNew(count: Int) -> Bool {
        if PersistanceData.shared.isNewData(count: count) {
            return true
        }
        return false
    }
    
    private func sendCategory(category: NSDictionary, id: Int) {
        guard let img1 = category["iconImage"] as? String,
        let name = category["name"] as? String,
        let sort = category["sortOrder"] as? String,
        let cat = category["subcategories"] as? NSArray
            else { return }
        let newCategory = Category()
        newCategory.id = id
        newCategory.iconImage = img1
        newCategory.name = name
        newCategory.sortOrder = Int(sort) ?? 999
        
        if cat.count == 0 {
            PersistanceData.shared.deleteCategory(id: id)
            return
        }
        PersistanceData.shared.saveCategory(category: newCategory)
        for elem in cat {
            
            if let tempSubCategory = elem as? NSDictionary {
                sendSubCategory(subCategory: tempSubCategory, id: id)
            }
        }

    }
    
    private func sendSubCategory(subCategory: NSDictionary, id: Int) {
        let newSubCategory = SubCategory()
        newSubCategory.id = id
        newSubCategory.idToSite = Int(subCategory["id"] as? String ?? "") ?? 0
        newSubCategory.name = subCategory["name"] as! String
        newSubCategory.sortOrder = Int(subCategory["sortOrder"] as? String ?? "") ?? 999
        PersistanceData.shared.saveSubCategory(subCategory: newSubCategory)
    }
            

}
