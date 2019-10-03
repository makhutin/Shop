//
//  DataNow.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import Foundation



struct Category {
    var id: Int = 0
    var iconImage: String = ""
    var name: String = ""
    var sortOrder: Int = 999
}

struct SubCategory {
    var id: Int = 0
    var iconImage: String = ""
    var idToSite: Int = 0
    var name: String = ""
    var sortOrder: Int = 999
}


class DataNow {
    static let shared = DataNow()
    
    var categoryData: String = ""
    
    
    let url = "https://blackstarshop.ru/"

    func loadData(complite: @escaping (_ new: Bool) -> Void) {
        category = []
        subCategory = []
        DataLoader.shared.loadCategory {
            new in
            if new {
                complite(true)
            }else{
                complite(false)
            }
        }
    }
    
    //MARK: save and load category data
    
    private var category: [Category] = []
    private var subCategory: [SubCategory] = []
    
    func addCategory(category: Category) {
        let newArray = self.category.filter { $0.id == category.id }
        if !newArray.isEmpty { return }
        self.category.append(category)
    }
    
    func loadCategory() -> [Category] {
        return category
    }
    
    func addSubCategory(subCategory: SubCategory) {
        let newArray = self.subCategory.filter { $0.idToSite == subCategory.idToSite }
        if !newArray.isEmpty { return }
        self.subCategory.append(subCategory)
    }
    
    func loadSubCatgory(id: Int) -> [SubCategory] {
        return subCategory.filter { $0.id == id }
    }
    
    
}
