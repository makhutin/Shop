//
//  PersistanceData.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var iconImage: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 999
}

class SubCategory: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var iconImage: String = ""
    @objc dynamic var idToSite: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 999
}

class CategoryDataCount: Object {
    @objc dynamic var count: Int = 0
}
/**
Data load, save
*/
class PersistanceData {
    
    static let shared = PersistanceData()
    
    private let realm = try! Realm()
    
}

// save and compasion of result.count
extension PersistanceData {
    
    func saveCategoryDataCount(count: Int) {
        let oldData = realm.objects(CategoryDataCount.self)
        let newData = CategoryDataCount()
        newData.count = count
        try! realm.write {
            for data in oldData {
                realm.delete(data)
            }
            realm.add(newData)
        }
    }
    
    func isNewData(count: Int) -> Bool {
        let oldData = realm.objects(CategoryDataCount.self).first
        if oldData?.count == count {
            return true
        }else {
            return false
        }
    }
}

// load,save,del category
extension PersistanceData {
    
    func loadCategory() -> [Category] {
        var result = [Category]()
        let oldData = realm.objects(Category.self)
        for elem in oldData {
            result.append(elem)
        }
        return result
    }
    
    
    func saveCategory(category: Category) {
        let oldData = realm.objects(Category.self).filter("id == \(category.id)")
        try! realm.write {
            for data in oldData {
                realm.delete(data)
            }
            realm.add(category)
        }
    }
    
    func deleteCategory(id: Int) {
        let oldData = realm.objects(Category.self).filter("id == \(id)")
        try! realm.write {
        for data in oldData {
            realm.delete(data)
            }
        }
        
    }
}

//load save subCategory
extension PersistanceData {
    
    func saveSubCategory(subCategory: SubCategory) {
        let oldData = realm.objects(SubCategory.self).filter("idToSite == \(subCategory.idToSite)")
        try! realm.write {
            for data in oldData {
                realm.delete(data)
            }
            realm.add(subCategory)
        }
    }
    
    func loadSubCategory(id: Int) -> [SubCategory] {
        let oldData = realm.objects(SubCategory.self).filter("id == \(id)")
        var result = [SubCategory]()
        for data in oldData {
            result.append(data)
        }
        return result
    }
}
