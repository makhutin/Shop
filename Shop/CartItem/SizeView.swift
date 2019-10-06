//
//  SizeView.swift
//  Shop
//
//  Created by Mahutin Aleksei on 06/10/2019.
//  Copyright © 2019 Mahutin Aleksei. All rights reserved.
//

import UIKit

protocol SizeViewDelegate {
    func sizeIsChoice(size: [String:String])
}

class SizeView: UIView,InterfaceIsDark {
    var intefaceIsDark: Bool { return traitCollection.userInterfaceStyle == .dark }
    
    
    var sizeData = [[String:String]]()
    var delegate: SizeViewDelegate?
    
    
    
    func loadSizes() {
        var y = 0
        let height = 56
        for (index,elem) in sizeData.reversed().enumerated() {
            let button = UIButton()
            button.tag = index
            button.setTitle("\(elem["size"] ?? "") количество: \(elem["quantity"] ?? "")", for: .normal)
            button.setTitleColor((intefaceIsDark ? .white : .black), for: .normal)
            button.backgroundColor = (intefaceIsDark ? .black : .white)
            self.addSubview(button)
            button.frame = CGRect(x: 0, y: y + 1 , width: Int(self.bounds.width), height: height)
            button.addTarget(self, action: #selector(pressSize), for: .touchUpInside)
            y += height + 1
        }
        self.frame.size = CGSize(width: self.bounds.width, height: CGFloat(y + height))
    }
    
    @objc func pressSize(sender: UIButton) {
        let data = sizeData.reversed()[sender.tag]
        delegate?.sizeIsChoice(size: data)
    }


}
