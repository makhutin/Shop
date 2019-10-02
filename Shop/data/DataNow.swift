//
//  DataNow.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import Foundation




class DataNow {
    static let shared = DataNow()
    
    var categoryData: String = ""
    var category: [Category] = []

    func loadData(complite: @escaping (_ new: Bool) -> Void) {
        category = PersistanceData.shared.loadCategory()
        DataLoader.shared.loadCategory {
            new in
            if new {
                self.category = PersistanceData.shared.loadCategory()
                complite(true)
            }else{
                complite(false)
            }
        }
    }
    
    
}
