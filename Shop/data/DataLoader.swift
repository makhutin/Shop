//
//  DataLoader.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/**
Load data from internet and sent to (PersistanceData is Realm)
*/
class DataLoader {
    
    static let shared = DataLoader()
    
    func loadShopItems(id: Int, complete:@escaping () -> Void) {
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)")!
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            response in
            if response.result.isSuccess {
                guard let jsonDict = response.result.value as? NSDictionary
                else { return }
                for (key,value) in jsonDict {
                        let id = key as! String
                    guard let jsonShopItem = value as? NSDictionary else { return }
                    self.sendShopItem(shopItems: jsonShopItem, id: id)
                }
            }
            complete()
        })
    }
    
    func loadCategory( complete:@escaping (_ new: Bool) -> Void) {
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            response in
            if response.result.isSuccess {
                    guard let jsonDict = response.result.value as? NSDictionary
                    else { return }
                    for (key,value) in jsonDict {
                            let id = Int(key as! String)!
                        guard let jsonCategory = value as? NSDictionary else { return }
                        self.sendCategory(category: jsonCategory, id: id)
                    }
                    complete(true)
            }else{
                complete(false)
            }
        })
    }
    
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else { return closure(nil) }
        Alamofire.request(url).validate().responseData(completionHandler: {
            data in
            guard data.error == nil else {
                return closure(nil)
            }
            guard data.response != nil else {
                return closure(nil)
            }
            guard data.data != nil else {
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data.data!))
            }
        })
    }

    
}

//send data to Persistance class (realm)
extension DataLoader {

    private func sendCategory(category: NSDictionary, id: Int) {
        guard let img1 = category["iconImage"] as? String,
        let name = category["name"] as? String,
        let sort = category["sortOrder"] as? String,
        let cat = category["subcategories"] as? NSArray
            else { return }
        let newCategory = Category(id: id,
                                   iconImage: img1,
                                   name: name,
                                   sortOrder: Int(sort) ?? 999)
        if cat.count == 0 && id != 74 { return }
        DataNow.shared.addCategory(category: newCategory)
        for elem in cat {
            if let tempSubCategory = elem as? NSDictionary {
                sendSubCategory(subCategory: tempSubCategory, id: id)
            }
        }

    }
    
    private func sendSubCategory(subCategory: NSDictionary, id: Int) {
        var tempId = id
        if subCategory["type"] as? String == "Collection" {
            tempId = 74
        }
        let newSubCategory = SubCategory(id: tempId,
                                         iconImage: subCategory["iconImage"] as? String ?? "",
                                         idToSite: Int(subCategory["id"] as? String ?? "") ?? 0,
                                         name: subCategory["name"] as! String,
                                         sortOrder: Int(subCategory["sortOrder"] as? String ?? "") ?? 999,
                                         type: subCategory["type"] as? String ?? "")
        DataNow.shared.addSubCategory(subCategory: newSubCategory)
    }
    
    private func sendShopItem(shopItems: NSDictionary, id:String) {
        var images = [String]()
        images.append(shopItems["mainImage"] as? String ?? "")
        guard let productsImage = shopItems["productImages"] as? NSArray else { return }
        for elem in productsImage {
            guard let data = elem as? NSDictionary else { continue }
            images.append(data["imageURL"] as? String ?? "")
        }
        
        var offers = [[String:String]]()
        guard let offersData = shopItems["offers"] as? NSArray else { return }
        for elem in offersData {
            guard let data = elem as? NSDictionary else { continue }
            offers.append(["size": data["size"] as? String ?? "",
                           "productOfferID": data["productOfferID"] as? String ?? "",
                           "quantity": data["quantity"] as? String ?? ""
            ])
        }
        
        let newShopItems = ShopItem(mainImage: images[0],
                                    name: shopItems["name"] as? String ?? "",
                                    price: Int(Double(shopItems["price"] as? String ?? "")!),
                                    id: id,
                                    sortOrder: Int(shopItems["sortOrder"] as? String ?? "") ?? 999,
                                    productImages: images,
                                    description: shopItems["description"] as? String ?? "",
                                    offers: offers)
        DataNow.shared.addShopItem(shopItem: newShopItems)
    }
            

}
