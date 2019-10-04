//
//  PersistanceData.swift
//  Shop
//
//  Created by Mahutin Aleksei on 02/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryDataCount: Object {
    @objc dynamic var count: Int = 0
}

class DataImage: Object {
    @objc dynamic var url:Int = 0
    @objc dynamic var data: Data = Data()
    @objc dynamic var date: Date = Date()
    @objc dynamic var notSourse: Bool = false
}
/**
Data load, save
*/
class PersistanceData {
    
    static let shared = PersistanceData()
    
    private let realm = try! Realm()
    
    //of days
    private let updateTimeForImage = 3
    
    func saveImage(image: UIImage,url: String) {
        let oldData = realm.objects(DataImage.self).filter("url = \(url.djb2hash)")
        let data = DataImage()
        data.data = image.pngData()!
        data.date = Date()
        data.notSourse = false
        data.url = url.djb2hash
        try! realm.write {
            for elem in oldData {
                realm.delete(elem)
            }
            realm.add(data)
        }
    }
    
    func saveFailData(url: String) {
        let oldData = realm.objects(DataImage.self).filter("url = \(url.djb2hash)")
        let data = DataImage()
        data.data = Data()
        data.date = Date()
        data.notSourse = true
        data.url = url.djb2hash
        try! realm.write {
            for elem in oldData {
                realm.delete(elem)
            }
            realm.add(data)
        }
    }
    
    func loadImage(url: String) -> UIImage? {
        let oldData = realm.objects(DataImage.self).filter("url = \(url.djb2hash)").first
        guard let notSource = oldData?.notSourse else { return nil }
        if notSource  {
            return UIImage(named: "NoImg")
        }else{
            if let data = oldData?.data {
                let now = Date().timeIntervalSince1970
                let defirence = Date(timeIntervalSince1970: now - oldData!.date.timeIntervalSince1970)
                let calendar = Calendar.current
                if calendar.component(.day, from: defirence) > updateTimeForImage {
                    print("is so old")
                    return nil }
                let image = UIImage(data: data)
            return image
                }
        }
        return nil
    }
    
    /**
     Delete data if date > PersistanceData.updateTimeForImage
    */
    func updateImage() {
        let oldData = realm.objects(DataImage.self)
        let dataForDel = oldData.filter { (data) -> Bool in
            let now = Date().timeIntervalSince1970
            let defirence = Date(timeIntervalSince1970: now - data.date.timeIntervalSince1970)
            let calendar = Calendar.current
            if calendar.component(.day, from: defirence) > self.updateTimeForImage {
                return true }
            return false
        }
        try! realm.write {
            for data in dataForDel {
                print("del")
                realm.delete(data)
            }
        }
    }
    
}


extension String {
    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}
